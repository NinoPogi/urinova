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
  bool _scanningComplete = false;

  @override
  void dispose() {
    _connectedDevice?.disconnect();
    super.dispose();
  }

  /// Returns the title for the current step
  String _getPageTitle() {
    switch (_currentStep) {
      case 0:
        return 'Connection';
      case 1:
        return 'Load the Dip Test';
      case 2:
        return 'Urine Loading';
      case 3:
        return 'Urine Unloading';
      case 4:
        return 'Scanning';
      case 5:
        return 'Test Summary';
      default:
        return 'Test';
    }
  }

  /// Checks if the user can proceed to the next step
  bool _canGoNext() {
    if (_currentStep == 0) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      return userProvider.currentProfile != null && _isConnected;
    }
    return true;
  }

  /// Sends a command to the Bluetooth device
  Future<void> _sendCommand(int command) async {
    if (_connectedDevice == null || !_isConnected) return;

    List<BluetoothService> services =
        await _connectedDevice!.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic c in service.characteristics) {
        if (c.characteristicUuid.toString() == dotenv.env['BLE_WRITE']) {
          await c.write([command], timeout: 180);
          break;
        }
      }
    }
  }

  /// Initiates the scanning process
  void _startScanning() async {
    if (_connectedDevice == null || !_isConnected || _isScanning) return;

    setState(() {
      _isScanning = true;
      _scanningComplete = false;
    });
    await _sendCommand(0x03); // Command to start scanning
  }

  /// Scans for and connects to the Bluetooth device
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
                if (dataType == 0x02 && received.length >= 2) {
                  // Handle liquid level or other data
                } else if (dataType == 0x04 && received.length >= 11) {
                  List<int> biomarkers = received.sublist(1, 11);
                  Provider.of<BiomarkerProvider>(context, listen: false)
                      .updateBiomarkers(biomarkers);
                } else if (dataType == 0x05) {
                  setState(() {
                    _isScanning = false;
                    _scanningComplete = true;
                  });
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

  /// Handles confirmation and saves test data
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
      biomarkerProvider.loadHistoryForProfile(
          userId, profileId); // Reload history
    }
    Navigator.of(context).pop();
  }

  /// Builds the Connection page UI
  Widget _buildConnectionPage() {
    final userProvider = Provider.of<UserProvider>(context);
    return Column(
      children: [
        Image.asset('assets/images/device.gif', height: 154),
        const Text('Select Profile'),
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
        const SizedBox(height: 20),
        Text('Current Time: ${DateTime.now().toString()}'),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _isScanning || _isConnected ? null : _startScanAndConnect,
          child: Text(_isScanning ? 'Scanning...' : 'Connect Device'),
        ),
        if (_isConnected) const Text('Device Connected'),
      ],
    );
  }

  /// Builds the Load Dip Test page UI
  Widget _buildLoadDipTestPage() {
    return Column(
      children: [
        const Text('Load the Dip Test'),
        Image.asset('assets/images/load_dip_test.gif'),
        const Text('Instructions: Place the dip test in the slot as shown.'),
      ],
    );
  }

  /// Builds the Urine Loading page UI
  Widget _buildUrineLoadingPage() {
    return Column(
      children: [
        const Text('Urine Loading'),
        Image.asset('assets/images/urine_loading.gif'),
        const Text('Instructions: Load the urine sample as shown.'),
        const SizedBox(height: 20),
      ],
    );
  }

  /// Builds the Urine Unloading page UI
  Widget _buildUrineUnloadingPage() {
    return Column(
      children: [
        const Text('Urine Unloading'),
        Image.asset('assets/images/urine_unloading.gif'),
        const Text(
            'Instructions: Unload the urine sample as shown, after a minute.'),
      ],
    );
  }

  /// Builds the Scanning page UI
  Widget _buildScanningPage() {
    return Column(
      children: [
        const Text('Scanning Page'),
        _isScanning
            ? Container(
                height: 50,
                child: const Center(child: CircularProgressIndicator()))
            : const Text('Press Scan Now to start scanning'),
      ],
    );
  }

  /// Builds the Test Summary page UI
  Widget _buildTestSummaryPage() {
    final biomarkerProvider = Provider.of<BiomarkerProvider>(context);
    return Column(
      children: [
        const Text('Test Summary'),
        ...biomarkerProvider.biomarkers.asMap().entries.map((entry) {
          final index = entry.key;
          final value = entry.value;
          if (index >= biomarkerNames.length ||
              index >= biomarkerValues.length) {
            return const SizedBox();
          }
          return ListTile(
            title: Text(biomarkerNames[index]),
            subtitle: (value < biomarkerValues[index].length)
                ? Text(biomarkerValues[index][value])
                : const Text("Invalid value"),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (_currentStep) {
      case 0:
        body = _buildConnectionPage();
        break;
      case 1:
        body = _buildLoadDipTestPage();
        break;
      case 2:
        body = _buildUrineLoadingPage();
        break;
      case 3:
        body = _buildUrineUnloadingPage();
        break;
      case 4:
        body = _buildScanningPage();
        break;
      case 5:
        body = _buildTestSummaryPage();
        break;
      default:
        body = const SizedBox.shrink();
    }

    Widget rightButton;
    if (_currentStep < 3) {
      // Connection, Load Dip Test, Urine Loading
      rightButton = ElevatedButton(
        onPressed: _isScanning || !_canGoNext()
            ? null
            : () => setState(() => _currentStep++),
        child: const Text('Next'),
      );
    } else if (_currentStep == 3) {
      // Urine Unloading
      rightButton = ElevatedButton(
        onPressed: _isScanning || !_canGoNext()
            ? null
            : () async {
                setState(() => _isScanning = true);
                await _sendCommand(0x01); // Send 0x01 command for unloading
                setState(() {
                  _isScanning = false;
                  _currentStep++;
                });
              },
        child: _isScanning ? const Text('Processing...') : const Text('Next'),
      );
    } else if (_currentStep == 4) {
      // Scanning
      if (!_isScanning && !_scanningComplete) {
        rightButton = ElevatedButton(
            onPressed: _startScanning, child: const Text('Scan Now'));
      } else if (_scanningComplete) {
        rightButton = ElevatedButton(
            onPressed: () => setState(() => _currentStep++),
            child: const Text('Next'));
      } else {
        rightButton =
            ElevatedButton(onPressed: null, child: const Text('Scanning...'));
      }
    } else if (_currentStep == 5) {
      // Test Summary
      rightButton =
          ElevatedButton(onPressed: _onConfirm, child: const Text('Done'));
    } else {
      rightButton = const SizedBox.shrink();
    }

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
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Work Sans",
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1),
                      body,
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentStep > 0 && _currentStep < 6)
                        ElevatedButton(
                          onPressed: () => setState(() => _currentStep--),
                          child: const Text('Previous'),
                        )
                      else
                        const SizedBox(width: 100),
                      rightButton,
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
