// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
//
// class ControlPage extends StatelessWidget {
//   final BluetoothConnection connection;
//
//   ControlPage({required this.connection});
//
//   @override
//   Widget build(BuildContext context) {
//     // Lock the orientation to landscape
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('RC Car Control'),
//       ),
//       body: SingleChildScrollView(child: _buildControlPage()),
//     );
//   }
//
//   Widget _buildControlPage() {
//     return Stack(
//         children:<Widget>[ Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           mainAxisSize:MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ElevatedButton(
//             //   onPressed: () => _sendCommand('F'),
//             //   child: Text('Forward'),
//             // ),
//
//             Padding(
//               padding: EdgeInsets.only(left: 80),
//               child: GestureDetector(
//                   onTap: () => _sendCommand('F'),
//
//                   child: Image.asset("assets/images/up_button.png",width: 30,height: 30,)),
//             ),
//             SizedBox(height: 30),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.only(left: 40),
//                   child: GestureDetector(
//                       onTap: () => _sendCommand('L'),
//
//                       child: Image.asset("assets/images/left_arrow.png",width: 30,height: 30,)),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(left: 40),
//                   child: GestureDetector(
//                       onTap: () => _sendCommand('R'),
//
//                       child: Image.asset("assets/images/right_button.png",width: 30,height: 30,)),
//                 ),
//               ],
//             ),
//             SizedBox(height: 30),
//             Padding(
//               padding: EdgeInsets.only(left: 80),
//               child: GestureDetector(
//                   onTap: () => _sendCommand('B'),
//
//                   child: Image.asset("assets/images/backward_button.png",width: 30,height: 30,)),
//             ),
//             SizedBox(height: 30),
//             Padding(
//               padding: EdgeInsets.only(left: 120),
//               child: ElevatedButton(
//                 onPressed: () => _sendCommand('S'),
//                 child: Text('Stop'),
//               ),
//             ),
//           ],
//         )]
//     );
//   }
//
//   void _sendCommand(String command) async {
//     connection.output.add(utf8.encode(command + '\r\n'));
//     await connection.output.allSent;
//     // You can add any additional logic or UI updates based on the command if needed
//   }
// }
