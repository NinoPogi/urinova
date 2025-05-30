import 'package:flutter/material.dart';
import 'package:urinova/urinova.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(Urinova());
}

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await dotenv.load(fileName: ".env");
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'RGB Color Sensor App',
//       home: ColorSensorWidget(),
//     );
//   }
// }

// class ColorSensorWidget extends StatefulWidget {
//   @override
//   _ColorSensorWidgetState createState() => _ColorSensorWidgetState();
// }

// class _ColorSensorWidgetState extends State<ColorSensorWidget> {
//   BluetoothDevice? _connectedDevice;
//   bool _isConnected = false;
//   bool _isScanning = false;
//   int _r = 0, _g = 0, _b = 0;
//   BluetoothCharacteristic? _writeCharacteristic;

//   @override
//   void dispose() {
//     _connectedDevice?.disconnect();
//     super.dispose();
//   }

//   void _startScanAndConnect() async {
//     if (_isScanning) return;
//     setState(() => _isScanning = true);

//     await FlutterBluePlus.startScan(
//       timeout: Duration(seconds: 4),
//       withNames: ["ESP32_Color"],
//     );

//     var sub = FlutterBluePlus.onScanResults.listen((results) async {
//       if (results.isEmpty) return;
//       var r = results.last;
//       FlutterBluePlus.stopScan();

//       try {
//         await r.device.connect();
//         if (!mounted) return;

//         var services = await r.device.discoverServices();
//         for (var service in services) {
//           for (var ch in service.characteristics) {
//             final uuid = ch.characteristicUuid.toString();
//             if (uuid == dotenv.env['BLE_NOTIFY']) {
//               await ch.setNotifyValue(true);
//               ch.onValueReceived.listen((data) {
//                 if (data.length >= 3) {
//                   setState(() {
//                     _r = data[0];
//                     _g = data[1];
//                     _b = data[2];
//                     print('[BLE] Received RGB: $_r,$_g,$_b');
//                   });
//                 }
//               });
//             } else if (uuid == dotenv.env['BLE_WRITE']) {
//               _writeCharacteristic = ch;
//             }
//           }
//         }

//         setState(() {
//           _connectedDevice = r.device;
//           _isConnected = true;
//           _isScanning = false;
//         });

//         r.device.connectionState.listen((state) {
//           if (state == BluetoothConnectionState.disconnected) {
//             if (!mounted) return;
//             setState(() => _isConnected = false);
//           }
//         });
//       } catch (e) {
//         if (!mounted) return;
//         setState(() {
//           _isScanning = false;
//           _isConnected = false;
//         });
//       }
//     });

//     FlutterBluePlus.cancelWhenScanComplete(sub);

//     Future.delayed(Duration(seconds: 5), () {
//       if (!_isConnected && mounted) {
//         setState(() => _isScanning = false);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('RGB Color Sensor')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 200,
//               height: 200,
//               decoration: BoxDecoration(
//                 color: Color.fromRGBO(_r, _g, _b, 1.0),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text('R: $_r, G: $_g, B: $_b'),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _isConnected ? null : _startScanAndConnect,
//               child: Text(_isConnected ? 'Connected' : 'Connect'),
//             ),
//             if (_isConnected)
//               ElevatedButton(
//                 onPressed: () {
//                   _connectedDevice?.disconnect();
//                   setState(() => _isConnected = false);
//                 },
//                 child: Text('Disconnect'),
//               ),
//             if (_isConnected && _writeCharacteristic != null)
//               ElevatedButton(
//                 onPressed: () async {
//                   await _writeCharacteristic!.write([0x01]);
//                 },
//                 child: Text('Start Measurement'),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
