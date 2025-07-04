import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import '../../providers/biomarker_provider.dart';

class DeviceStatusWidget extends StatefulWidget {
  const DeviceStatusWidget({super.key, required this.onTestComplete});
  final VoidCallback onTestComplete;

  @override
  State<DeviceStatusWidget> createState() => _DeviceStatusWidgetState();
}

class _DeviceStatusWidgetState extends State<DeviceStatusWidget> {
  BluetoothDevice? _connectedDevice;
  bool _isConnected = false;
  bool _isScanning = false;
  bool _isSending = false;

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

    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 4),
      withNames: ["Urinova"],
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
                  dotenv.env['BLE_NOTIFY']) {
                await characteristic.setNotifyValue(true);

                characteristic.onValueReceived.listen((received) {
                  if (!mounted) return;

                  List<int> firstBytes = [];
                  for (int i = 0; i < received.length; i += 4) {
                    firstBytes.add(received[i]);
                  }

                  if (mounted) {
                    Provider.of<BiomarkerProvider>(context, listen: false)
                        .updateBiomarkers(firstBytes);
                  }

                  if (received.isNotEmpty && received[0] == 0x02) {
                    widget.onTestComplete();
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

  void _sendData() async {
    if (_connectedDevice == null || !_isConnected || _isSending) return;

    setState(() {
      _isSending = true;
    });

    List<BluetoothService> services =
        await _connectedDevice!.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.characteristicUuid.toString() ==
            dotenv.env['BLE_WRITE']) {
          await characteristic.write([0x01], timeout: 120);
          break;
        }
      }
    }

    if (mounted) {
      setState(() {
        _isSending = false;
      });
      // widget.onTestComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 246, 238),
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Row(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/images/device.gif',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row(
                          //   children: [
                          //     Text(
                          //       'Battery: $_batteryLevel%',
                          //       style: TextStyle(
                          //         fontSize: 14,
                          //         color: _getLevelColor(_batteryLevel),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          // Row(
                          //   children: [
                          //     Text(
                          //       'Urine Level: $_urineLevel%',
                          //       style: TextStyle(
                          //         fontSize: 14,
                          //         color: _getLevelColor(_urineLevel),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.015),
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
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.03,
                                vertical:
                                    MediaQuery.of(context).size.height * 0.015,
                              ),
                            ),
                            child: _isScanning
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : Text(
                                    _isConnected ? "Connected" : "Connect",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            ElevatedButton(
              onPressed: _isConnected && !_isSending ? _sendData : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isSending
                    ? Colors.grey
                    : (_isConnected ? Colors.orange : Colors.grey),
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.25,
                  vertical: MediaQuery.of(context).size.height * 0.015,
                ),
              ),
              child: _isSending
                  ? const Text("Testing...", style: TextStyle(fontSize: 18))
                  : const Text("Test", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ],
    );
  }
}
