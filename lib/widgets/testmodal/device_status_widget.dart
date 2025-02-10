import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import '../../providers/biomarker_provider.dart';

class DeviceStatusWidget extends StatefulWidget {
  const DeviceStatusWidget({super.key});

  @override
  State<DeviceStatusWidget> createState() => _DeviceStatusWidgetState();
}

class _DeviceStatusWidgetState extends State<DeviceStatusWidget> {
  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _bluetoothCharacteristic;
  bool _isConnected = false;
  bool _isScanning = false;
  int closestColor = 7;

  List<String> colorList = [
    "Red",
    "Orange",
    "Yellow",
    "Green",
    "Blue",
    "Indigo",
    "Violet",
    " "
  ];

  List<MaterialColor> bgList = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.grey,
  ];

  @override
  void dispose() {
    super.dispose();
    if (_connectedDevice != null) {
      _connectedDevice!.disconnect();
    }
  }

  void _startScanAndConnect() async {
    if (_isScanning) return;
    setState(() {
      _isScanning = true;
    });

    print(dotenv.env['BLE_CHARACTERISTIC_UUID']);

    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 4),
      withNames: ["ESP32"],
    );

    var subscription = FlutterBluePlus.onScanResults.listen((results) async {
      if (results.isNotEmpty) {
        ScanResult r = results.last;
        FlutterBluePlus.stopScan();

        try {
          await r.device.connect();
          if (!mounted) return;

          List<BluetoothService> services = await r.device.discoverServices();

          for (BluetoothService service in services) {
            List<BluetoothCharacteristic> characteristics =
                service.characteristics;
            for (BluetoothCharacteristic characteristic in characteristics) {
              if (characteristic.characteristicUuid.toString() ==
                  dotenv.env['BLE_CHARACTERISTIC_UUID']) {
                await characteristic.setNotifyValue(true);

                characteristic.onValueReceived.listen((value) {
                  if (!mounted) return;
                  print(value);

                  setState(() {
                    closestColor = value[0];
                  });

                  // Update biomarkers
                  List<String> biomarkers =
                      value.map((e) => e.toString()).toList();
                  if (mounted) {
                    Provider.of<BiomarkerProvider>(context, listen: false)
                        .updateBiomarkers(biomarkers);
                  }
                });
              }
            }
          }

          if (mounted) {
            setState(() {
              _connectedDevice = r.device;
              _isConnected = true;
              _isScanning = false;
            });
          }

          r.device.connectionState.listen((state) {
            if (state == BluetoothConnectionState.disconnected) {
              if (!mounted) return;
              setState(() {
                _connectedDevice = null;
                _isConnected = false;
              });
            }
          });
        } catch (e) {
          if (mounted) {
            setState(() {
              _isScanning = false;
              _isConnected = false;
            });
          }
        }
      }
    });

    FlutterBluePlus.cancelWhenScanComplete(subscription);

    Future.delayed(const Duration(seconds: 5), () {
      if (!_isConnected && mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            children: [
              Text(
                'Device Status',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    height: 120,
                    width: 135,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/device.gif',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_isConnected) {
                            _connectedDevice?.disconnect();
                            setState(() {
                              _isConnected = false;
                            });
                          } else {
                            _startScanAndConnect();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _isConnected ? Colors.green : Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                        ),
                        child: _isScanning
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                _isConnected ? "Connected" : "Connect to ESP32",
                                style: const TextStyle(fontSize: 18),
                              ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () async {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: bgList[closestColor],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                        ),
                        child: Text(
                          colorList[closestColor],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
