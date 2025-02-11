import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urinova/constants/biomarker_constant.dart';
import 'package:urinova/providers/biomarker_provider.dart';
import 'package:urinova/widgets/testmodal/device_status_widget.dart';

class TestBottomSheet extends StatefulWidget {
  const TestBottomSheet({super.key});

  @override
  State<TestBottomSheet> createState() => _TestBottomSheetState();
}

class _TestBottomSheetState extends State<TestBottomSheet> {
  bool _showSummary = false;

  @override
  void initState() {
    super.initState();
  }

  void _onTestComplete() {
    setState(() {
      _showSummary = true;
    });
  }

  void _onConfirm() {
    Navigator.of(context).pop();
    setState(() {
      _showSummary = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final biomarkerProvider = Provider.of<BiomarkerProvider>(context);

    return Container(
      color: Colors.transparent,
      child: DraggableScrollableSheet(
        initialChildSize: 0.81,
        minChildSize: 0.7,
        maxChildSize: 0.81,
        builder: (BuildContext context, ScrollController scrollController) {
          return Material(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            color: const Color.fromARGB(255, 255, 162, 82),
            elevation: 4,
            child: _showSummary
                ? ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      const Text(
                        'Test Summary 🚽',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Work Sans",
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...biomarkerProvider.biomarkers
                          .asMap()
                          .entries
                          .map((entry) {
                        final index = entry.key;
                        final value = entry.value;

                        if (index >= biomarkerNames.length ||
                            index >= biomarkerValues.length) {
                          return SizedBox(); // Prevents RangeError by skipping invalid indexes.
                        }

                        return ListTile(
                          title: Text(
                            biomarkerNames[index],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: (value < biomarkerValues[index].length)
                              ? Text(
                                  biomarkerValues[index][value],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Invalid value",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.red),
                                ),
                        );
                      }),
                      ElevatedButton(
                        onPressed: _onConfirm,
                        child: const Text('Confirm'),
                      ),
                    ],
                  )
                : ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      const Text(
                        'Test Now 🚽',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Work Sans",
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      DeviceStatusWidget(onTestComplete: _onTestComplete),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// class TestBottomSheet extends StatefulWidget {
//   const TestBottomSheet({super.key});

//   @override
//   State<TestBottomSheet> createState() => _TestBottomSheetState();
// }

// class _TestBottomSheetState extends State<TestBottomSheet> {
//   BluetoothDevice? _connectedDevice;
//   bool _isConnected = false;
//   bool _isScanning = false;

//   @override
//   void initState() {
//     super.initState();
//   }

//   void _startScanAndConnect() async {
//     if (_isScanning) return;
//     setState(() {
//       _isScanning = true;
//     });

//     //if press turn on automatically

//     await FlutterBluePlus.startScan(
//       timeout: Duration(seconds: 4),
//       withNames: ["ESP32"],
//     );

//     var subscription = FlutterBluePlus.onScanResults.listen((results) async {
//       if (results.isNotEmpty) {
//         ScanResult r = results.last;

//         FlutterBluePlus.stopScan();

//         try {
//           await r.device.connect();
//           if (!mounted) return;

//           List<BluetoothService> services = await r.device.discoverServices();

//           for (BluetoothService service in services) {
//             List<BluetoothCharacteristic> characteristics =
//                 service.characteristics;
//             for (BluetoothCharacteristic characteristic in characteristics) {
//               if (characteristic.characteristicUuid.toString() ==
//                   "c91d35e8-6281-4c7b-97fa-5e892b345f1c") {
//                 await characteristic.setNotifyValue(true);

//                 characteristic.onValueReceived.listen((value) {
//                   print(value);
//                 });
//               }
//             }
//           }

//           setState(() {
//             _connectedDevice = r.device;
//             _isConnected = true;
//             _isScanning = false;
//           });

//           r.device.connectionState.listen((state) {
//             if (state == BluetoothConnectionState.disconnected) {
//               if (!mounted) return;
//               setState(() {
//                 _connectedDevice = null;
//                 _isConnected = false;
//               });
//             }
//           });
//         } catch (e) {
//           setState(() {
//             _isScanning = false;
//             _isConnected = false;
//           });
//         }
//       }
//     });

//     FlutterBluePlus.cancelWhenScanComplete(subscription);

//     Future.delayed(Duration(seconds: 5), () {
//       if (!_isConnected) {
//         if (!mounted) return;
//         setState(() {
//           _isScanning = false;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.transparent,
//       child: DraggableScrollableSheet(
//         initialChildSize: 0.8,
//         minChildSize: 0.6,
//         maxChildSize: 0.8,
//         builder: (BuildContext context, ScrollController scrollController) {
//           return Material(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
//             color: const Color.fromARGB(255, 255, 162, 82),
//             elevation: 4,
//             child: ListView(
//               controller: scrollController,
//               padding: const EdgeInsets.all(16.0),
//               children: [
//                 const Text(
//                   'Test Now 🚽',
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: "Work Sans",
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Device Status:',
//                   style: TextStyle(fontSize: 16, color: Colors.white),
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     const Spacer(),
//                     Container(
//                       width: 95,
//                       height: 95,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: const [
//                           BoxShadow(color: Colors.black26, blurRadius: 4),
//                         ],
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.asset(
//                           'assets/images/device.png',
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     const Spacer(),
//                     Column(
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             if (_isConnected) {
//                               _connectedDevice?.disconnect();
//                               setState(() {
//                                 _isConnected = false;
//                               });
//                             } else {
//                               _startScanAndConnect();
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor:
//                                 _isConnected ? Colors.green : Colors.blue,
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 12, vertical: 12),
//                           ),
//                           child: _isScanning
//                               ? CircularProgressIndicator(color: Colors.white)
//                               : Text(
//                                   _isConnected
//                                       ? "Connected"
//                                       : "Connect to ESP32",
//                                   style: TextStyle(fontSize: 18),
//                                 ),
//                         ),
//                         const SizedBox(height: 12),
//                         ElevatedButton(
//                           onPressed: () async {},
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor:
//                                 !_isConnected ? Colors.blue : Colors.green,
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 12, vertical: 12),
//                           ),
//                           child: _isScanning
//                               ? CircularProgressIndicator(color: Colors.white)
//                               : Text(
//                                   !_isConnected
//                                       ? "not connected"
//                                       : "get services",
//                                   style: TextStyle(fontSize: 18),
//                                 ),
//                         ),
//                       ],
//                     ),
//                     const Spacer(),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
