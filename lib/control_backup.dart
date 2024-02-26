// import 'dart:convert';
//
// import 'package:avatar_glow/avatar_glow.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:speech_to_text/speech_to_text.dart';
//
// class ControlPage extends StatefulWidget {
//   final BluetoothConnection connection;
//
//   ControlPage({super.key, required this.connection});
//
//   @override
//   State<ControlPage> createState() => _ControlPageState();
// }
//
// class _ControlPageState extends State<ControlPage> {
//   bool _isListening = false;
//   SpeechToText speechToText = SpeechToText();
//   dynamic text = '';
//
//   @override
//   Widget build(BuildContext context) {
//     // Lock the orientation to landscape
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//
//
//
//     return Scaffold(
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: AvatarGlow(
//         animate: _isListening,
//         duration: Duration(milliseconds: 2000),
//         glowColor: Colors.greenAccent.shade700,
//         repeat: true,
//         glowShape: BoxShape.circle,
//         child: GestureDetector(
//           onTapDown: (details) async{
//             if(!_isListening){
//               bool available = await speechToText.initialize();
//               if (available){
//                 setState((){
//                   _isListening = true;
//                   speechToText.listen(
//                       onResult: (result){
//                         text  = result.recognizedWords;
//                         print('The text is: '+ text);
//                         if (text == 'forward') {
//                           _sendCommand('F');
//                         }
//                         else if (text == 'backward') {
//                           _sendCommand('B');
//                         }
//                         else if (text == 'left') {
//                           _sendCommand('L');
//                         }
//                         else if (text == 'right') {
//                           _sendCommand('R');
//                         }
//                         else if (text == 'stop') {
//                           _sendCommand('S');
//                         }
//
//                         text = '';
//
//                       }
//                   );
//                 }
//
//                 );
//
//               }
//             }
//           },
//
//           onTapUp: (details)  {
//
//
//             setState((){
//               _isListening = false;
//               text = '';
//             }
//             );
//             speechToText.stop();
//
//           },
//           child: CircleAvatar(
//             backgroundColor: Colors.greenAccent.shade700,
//             radius: 35,
//             child: Icon(_isListening? Icons.mic: Icons.mic_none,color: Colors.white,),
//           ),
//         ),
//       ),
//       appBar: AppBar(
//         title: Text('RC Car Control'),
//       ),
//       body: Stack(
//         children: <Widget>[
//           Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(left: 80),
//                 child: GestureDetector(
//                   onTapDown: (details) => _sendCommand('F'),
//                   onTapUp: (details) => _sendCommand('S'),
//                   child: Image.asset("assets/images/up_button.png",
//                       width: 30, height: 30),
//                 ),
//               ),
//               SizedBox(height: 30),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.only(left: 40),
//                     child: GestureDetector(
//                         onTapDown: (details) => _sendCommand('L'),
//                         onTapUp: (details) => _sendCommand('S'),
//                         child: Image.asset("assets/images/left_arrow.png",
//                             width: 30, height: 30)),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(left: 40),
//                     child: GestureDetector(
//                         onTapDown: (details) => _sendCommand('R'),
//                         onTapUp: (details) => _sendCommand('S'),
//                         child: Image.asset("assets/images/right_button.png",
//                             width: 30, height: 30)),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 30),
//               Padding(
//                 padding: EdgeInsets.only(left: 80),
//                 child: GestureDetector(
//                     onTapDown: (details) => _sendCommand('B'),
//                     onTapUp: (details) => _sendCommand('S'),
//                     child: Image.asset("assets/images/backward_button.png",
//                         width: 30, height: 30)),
//               ),
//               SizedBox(height: 30),
//               Padding(
//                 padding: EdgeInsets.only(left: 120),
//                 child: ElevatedButton(
//                   onPressed: () => _sendCommand('S'),
//                   child: Text('Stop'),
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//   void _sendCommand(String command) async {
//     widget.connection.output.add(utf8.encode('$command\r\n'));
//     await widget.connection.output.allSent;
//     // You can add any additional logic or UI updates based on the command if needed
//   }
// }
