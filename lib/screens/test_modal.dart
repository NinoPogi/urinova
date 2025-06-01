import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urinova/constants/biomarker_constant.dart';
import 'package:urinova/providers/biomarker_provider.dart';
import 'package:urinova/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TestBottomSheet extends StatefulWidget {
  const TestBottomSheet({super.key});

  @override
  State<TestBottomSheet> createState() => _TestBottomSheetState();
}

class _TestBottomSheetState extends State<TestBottomSheet> {
  int _currentStep = 0;
  BluetoothDevice? _connectedDevice;
  bool _isConnected = false;
  bool _isScanning = false;
  bool _isSending = false;
  int _liquidLevel = 0; // Mock value

  @override
  void dispose() {
    _connectedDevice?.disconnect();
    super.dispose();
  }

  String _getPageTitle() {
    switch (_currentStep) {
      case 0:
        return 'Connection';
      case 1:
        return 'Load the Dip Test';
      case 2:
        return 'Urine Loading';
      case 3:
        return 'Scanning';
      case 4:
        return 'Test Summary';
      default:
        return 'Test';
    }
  }

  bool _canGoNext() {
    if (_currentStep == 0) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      return userProvider.currentProfile != null && _isConnected;
    }
    return true;
  }

  void _startScanAndConnect() async {
    if (_isScanning) return;
    setState(() => _isScanning = true);
    await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 4), withNames: ["Urinova"]);
    var subscription = FlutterBluePlus.onScanResults.listen((results) async {
      if (results.isNotEmpty) {
        ScanResult r = results.last;
        FlutterBluePlus.stopScan();
        await r.device.connect();
        List<BluetoothService> services = await r.device.discoverServices();
        for (BluetoothService service in services) {
          for (BluetoothCharacteristic c in service.characteristics) {
            if (c.characteristicUuid.toString() == dotenv.env['BLE_NOTIFY']) {
              await c.setNotifyValue(true);
              c.onValueReceived.listen((received) {
                if (received.isEmpty) return;
                int dataType = received[0];
                if (dataType == 0x02) {
                  setState(() {
                    _isScanning = false;
                    _currentStep = 4;
                  });
                } else if (dataType == 0x03) {
                  if (received.length >= 2) {
                    int waterLevel = received[1];
                    setState(() => _liquidLevel = waterLevel);
                  }
                }
              });
            }
          }
        }
        setState(() {
          _connectedDevice = r.device;
          _isConnected = true;
          _isScanning = false;
        });
        r.device.connectionState.listen((state) {
          if (state == BluetoothConnectionState.disconnected) {
            setState(() => _isConnected = false);
          }
        });
      }
    });
    FlutterBluePlus.cancelWhenScanComplete(subscription);
    Future.delayed(const Duration(seconds: 5), () {
      if (!_isConnected && mounted) setState(() => _isScanning = false);
    });
  }

  void _startScanning() async {
    if (_connectedDevice == null || !_isConnected || _isSending) return;
    setState(() {
      _isScanning = true;
      _isSending = true;
    });
    List<BluetoothService> services =
        await _connectedDevice!.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic c in service.characteristics) {
        if (c.characteristicUuid.toString() == dotenv.env['BLE_WRITE']) {
          await c.write([0x01], timeout: 180);
          break;
        }
      }
    }
    setState(() => _isSending = false);
  }

  void _onConfirm() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final biomarkerProvider =
        Provider.of<BiomarkerProvider>(context, listen: false);
    final currentProfile = userProvider.currentProfile;
    if (currentProfile != null) {
      final profileId = currentProfile['id'];
      final userId = userProvider.user!.uid;
      final biomarkers = biomarkerProvider.biomarkers;
      final testData = {'date': Timestamp.now(), 'biomarkers': biomarkers};
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('profiles')
          .doc(profileId)
          .collection('tests')
          .add(testData);
    }
    Navigator.of(context).pop();
  }

  Widget _buildConnectionPage() {
    final userProvider = Provider.of<UserProvider>(context);
    return Column(
      children: [
        Text('Select Profile'),
        DropdownButton<Map<String, dynamic>>(
          value: userProvider.currentProfile,
          items: userProvider.profiles
              .map((profile) => DropdownMenuItem(
                    value: profile,
                    child: Text(profile['name']),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) userProvider.setCurrentProfile(value);
          },
        ),
        SizedBox(height: 20),
        Text('Current Time: ${DateTime.now().toString()}'),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _isConnected ? null : _startScanAndConnect,
          child: Text(_isScanning ? 'Scanning...' : 'Connect Device'),
        ),
        if (_isConnected) Text('Device Connected'),
      ],
    );
  }

  Widget _buildLoadDipTestPage() {
    return Column(
      children: [
        Text('Load the Dip Test'),
        Image.asset('assets/images/load_dip_test.gif'),
        Text('Instructions: Place the dip test in the slot as shown.'),
      ],
    );
  }

  Widget _buildUrineLoadingPage() {
    return Column(
      children: [
        Text('Urine Loading'),
        Image.asset('assets/images/urine_loading.gif'),
        Text('Instructions: Load the urine sample as shown.'),
        SizedBox(height: 20),
        Text('Liquid Sensor Reading: $_liquidLevel%'),
      ],
    );
  }

  Widget _buildScanningPage() {
    return Column(
      children: [
        Text('Scanning Page'),
        _isScanning
            ? Container(
                height: 50, child: Center(child: CircularProgressIndicator()))
            : Text('Press Scan Now to start scanning'),
      ],
    );
  }

  Widget _buildTestSummaryPage() {
    final biomarkerProvider = Provider.of<BiomarkerProvider>(context);
    return Column(
      children: [
        Text('Test Summary'),
        ...biomarkerProvider.biomarkers.asMap().entries.map((entry) {
          final index = entry.key;
          final value = entry.value;
          if (index >= biomarkerNames.length || index >= biomarkerValues.length)
            return SizedBox();
          return ListTile(
            title: Text(biomarkerNames[index]),
            subtitle: (value < biomarkerValues[index].length)
                ? Text(biomarkerValues[index][value])
                : Text("Invalid value"),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.6,
        builder: (BuildContext context, ScrollController scrollController) {
          return Material(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            color: const Color.fromARGB(255, 255, 162, 82),
            elevation: 4,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20.0),
                    children: [
                      Text(
                        _getPageTitle(),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Work Sans",
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1),
                      if (_currentStep == 0) _buildConnectionPage(),
                      if (_currentStep == 1) _buildLoadDipTestPage(),
                      if (_currentStep == 2) _buildUrineLoadingPage(),
                      if (_currentStep == 3) _buildScanningPage(),
                      if (_currentStep == 4) _buildTestSummaryPage(),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentStep > 0 && _currentStep < 4)
                        ElevatedButton(
                          onPressed: () => setState(() => _currentStep--),
                          child: Text('Previous'),
                        )
                      else
                        SizedBox(width: 100),
                      if (_currentStep < 3)
                        ElevatedButton(
                          onPressed: () {
                            if (_canGoNext()) setState(() => _currentStep++);
                          },
                          child: Text('Next'),
                        )
                      else if (_currentStep == 3)
                        ElevatedButton(
                          onPressed: _isScanning ? null : _startScanning,
                          child: Text('Scan Now'),
                        )
                      else if (_currentStep == 4)
                        ElevatedButton(
                          onPressed: _onConfirm,
                          child: Text('Done'),
                        ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
