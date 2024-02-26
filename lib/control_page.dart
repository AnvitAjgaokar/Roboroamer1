import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ControlPage extends StatefulWidget {
  final BluetoothConnection connection;

  ControlPage({super.key, required this.connection});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  bool _isListening = false;
  SpeechToText speechToText = SpeechToText();
  dynamic text = '';

  @override
  Widget build(BuildContext context) {
    // Lock the orientation to landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,

    ]);



    return Scaffold(


      body: Stack(
        // alignment: Alignment.center,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFF070F2B), Color(0xFF1B1A55),Color(0xFF535C91)],
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    stops: [0.0, 0.5,1.0],
                    tileMode: TileMode.clamp)),
          ),
          Padding(
            padding: EdgeInsets.only(left: 250,top:50),
            child: Text(
              "RoboRoamer Remote",

              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Aldrich',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
              fontSize: 20),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left: 15,top: 80),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(15), // Rounded corners
                border: Border.all(color: Colors.white54, width: 3), // White border
              ),
              width: 700,
              height: 270,
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 270, left: 180),
            child: AvatarGlow(
              animate: _isListening,
              duration: Duration(milliseconds: 2000),
              glowColor: Colors.white,
              repeat: true,
              glowShape: BoxShape.circle,
              child: GestureDetector(
                onTapDown: (details) async{
                  print('tapped');
                  if(!_isListening){
                    bool available = await speechToText.initialize();
                    if (available){
                      setState((){
                        _isListening = true;
                        speechToText.listen(
                            onResult: (result){
                              text  = result.recognizedWords;
                              print('The text is: '+ text);
                              if (text == 'forward') {
                                _sendCommand('F');
                                print('forward');
                              }
                              else if (text == 'backward') {
                                _sendCommand('B');
                                print('backward');
                              }
                              else if (text == 'left') {
                                _sendCommand('L');
                                print('left');
                              }
                              else if (text == 'right') {
                                _sendCommand('R');
                                print('right');
                              }
                              else if (text == 'stop') {
                                _sendCommand('S');
                              }

                              text = '';

                            }
                        );
                      }

                      );

                    }
                  }
                },

                onTapUp: (details)  {

                  speechToText.stop();
                  setState((){
                    _isListening = false;
                    text = '';
                  }
                  );


                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Icon(_isListening? Icons.mic: Icons.mic_none,color: Colors.black,size: 30,),
                ),
              ),
            ),
          ),

          GestureDetector(
              onTapDown: (details) => _sendCommand('S'),
              onTapUp: (details) => _sendCommand('S'),
              child: Padding(
                padding: EdgeInsets.only(top: 260, left: 470),
                child: Image.asset(
                  "assets/images/stop.png",
                  width: 70,
                  height: 70,
                ),
              )),
          Padding(
            padding: EdgeInsets.only(top: 285, left: 488),
              child: Text(
            'Stop',
            style: TextStyle(
              fontFamily: 'Aldrich',
              fontWeight: FontWeight.bold,
            ),
          )),
          GestureDetector(
              onTapDown: (details) => _sendCommand('F'),
              onTapUp: (details) => _sendCommand('S'),
              child: Padding(
            padding: EdgeInsets.only(top: 120, left: 50),
            child: Image.asset(
              "assets/images/Up_Buttoncontrol.png",
            ),
          )),
          GestureDetector(
              onTapDown: (details) => _sendCommand('B'),
              onTapUp: (details) => _sendCommand('S'),
              child: Padding(
            padding: EdgeInsets.only(top: 230, left: 50),
            child: Image.asset(
              "assets/images/down_Buttoncontrol.png",
            ),
          )),

          Padding(
            padding: EdgeInsets.only(left: 590,top: 170),
            child: Transform.scale(
              scale: 1.2, // Adjust the scale factor as needed
              child: Image.asset(
                "assets/images/black_car_flip.png",
                height: 180, // Adjust the height if necessary
              ),
            ),
          ),
          GestureDetector(
              onTapDown: (details) => _sendCommand('L'),
              onTapUp: (details) => _sendCommand('S'),
              child: Padding(
            padding: EdgeInsets.only(top: 160, left: 530),
            child: Image.asset(
              "assets/images/left_Buttoncontrol.png",
            ),
          )),
          GestureDetector(
              onTapDown: (details) => _sendCommand('R'),
              onTapUp: (details) => _sendCommand('S'),
              child: Padding(
            padding: EdgeInsets.only(top: 160, left: 630),
            child: Image.asset("assets/images/right_Buttoncontrol.png",),)),


        ],
      ),
    );
  }

  void _sendCommand(String command) async {
    widget.connection.output.add(utf8.encode('$command\r\n'));
    print('${command.toString()}');
    await widget.connection.output.allSent;
    // You can add any additional logic or UI updates based on the command if needed
  }
}
