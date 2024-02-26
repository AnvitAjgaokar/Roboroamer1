import 'dart:async';
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'control_page.dart';

class BluetoothApp extends StatefulWidget {

  @override
  _BluetoothAppState createState() => _BluetoothAppState();
}

class _BluetoothAppState extends State<BluetoothApp> {
// Initializing the Bluetooth connection state to be unknown
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
// Initializing a global key, as it would help us in showing a SnackBar later
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
// Get the instance of the Bluetooth
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
// Track the Bluetooth connection with the remote device
  BluetoothConnection? connection;

  int? _deviceState;

  bool isDisconnecting = false;



// To track whether the device is still connected to Bluetooth
  bool get isConnected => connection != null && connection!.isConnected;

// Define some variables, which will be required later
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice? _device;
  bool _connected = false;

  bool _isButtonUnavailable = false;

  @override
  void initState() {
    super.initState();

// Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    _deviceState = 0; // neutral

// If the bluetooth of the device is not enabled,
// then request permission to turn on bluetooth
// as the app starts up
    enableBluetooth();

// Listen for further state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          _isButtonUnavailable = true;
        }
        getPairedDevices();
      });
    });
  }

  @override
  void dispose() {
// Avoid memory leak and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.dispose();
  }

// Request Bluetooth permission from the user
  Future<bool> enableBluetooth() async {
// Retrieving the current Bluetooth state
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

// If the bluetooth is off, then turn it on first
// and then retrieve the devices that are paired.
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

// For retrieving and storing the paired devices
// in a list.
  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

// To get the list of paired devices
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

// It is an error to call [setState] unless [mounted] is true.
    if (!mounted) {
      return;
    }

// Store the [devices] list in the [_devicesList] for accessing
// the list outside this class
    setState(() {
      _devicesList = devices;
    });
  }

// Now, its time to build the UI
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          alignment: Alignment.center,
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

            Container(
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(15), // Rounded corners
                border: Border.all(color: Colors.white54, width: 3), // White border
              ),
              width: 330,
              height: 650,

              child:  Padding(
                padding: EdgeInsets.only(left: 5,right: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20,),
                    Text(
                      "Paired Devices",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    // const SizedBox(height: 5), // Adjust spacing between text and list
                    Expanded(
                      child: ListView.builder(
                        itemCount: _devicesList.length,
                        itemBuilder: (context, index) {
                          BluetoothDevice device = _devicesList[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Card(
                              elevation: 10, // Adjust elevation as needed
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40), // Rounded corners
                              ),
                              color: Colors.white, // Tile color
                              child: ListTile(
                                title: Text(
                                  device.name.toString(),
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  device.address,
                                  style: TextStyle(color: Colors.black),
                                ),
                                onTap: () => _isButtonUnavailable ? null : _showConnectDialog(device),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top:490, right: 173),
              child: Transform.scale(
                scale: 1.5, // Adjust the scale factor as needed
                child: Image.asset(
                  "assets/images/black_car.png",
                  height: 180, // Adjust the height if necessary
                ),
              ),
            )



          ],
        ),
        // body: Container(
        //   decoration: const BoxDecoration(
        //       gradient: LinearGradient(
        //           colors: [Color(0xFF070F2B), Color(0xFF1B1A55),Color(0xFF535C91)],
        //           begin: FractionalOffset.topCenter,
        //           end: FractionalOffset.bottomCenter,
        //           stops: [0.0, 0.5,1.0],
        //           tileMode: TileMode.clamp)),
        //   child: Stack(
        //     alignment: Alignment.center,
        //     children: <Widget>[
        //
        //       Container(
        //         width:300 ,
        //         height: 500,
        //         color: Colors.white54.withOpacity(1.0),
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.all(15.0),
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             SizedBox(height: 20,),
        //             Text(
        //               "Connected Devices",
        //               style: TextStyle(
        //                 fontSize: 24,
        //                 fontWeight: FontWeight.bold,
        //                 color: Colors.white,
        //               ),
        //             ),
        //             // const SizedBox(height: 5), // Adjust spacing between text and list
        //             Expanded(
        //               child: ListView.builder(
        //                 itemCount: _devicesList.length,
        //                 itemBuilder: (context, index) {
        //                   BluetoothDevice device = _devicesList[index];
        //
        //                   return Padding(
        //                     padding: const EdgeInsets.symmetric(vertical: 8.0),
        //                     child: Card(
        //                       elevation: 8, // Adjust elevation as needed
        //                       shape: RoundedRectangleBorder(
        //                         borderRadius: BorderRadius.circular(40), // Rounded corners
        //                       ),
        //                       color: Colors.white, // Tile color
        //                       child: ListTile(
        //                         title: Text(
        //                           device.name.toString(),
        //                           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        //                         ),
        //                         subtitle: Text(
        //                           device.address,
        //                           style: TextStyle(color: Colors.black),
        //                         ),
        //                         onTap: () => _isButtonUnavailable ? null : _showConnectDialog(device),
        //                       ),
        //                     ),
        //                   );
        //                 },
        //               ),
        //             ),
        //           ],
        //         ),
        //       )
        //     ],
        //   ),
        // ),
      ),
    );
  }



  void _connectToDevice(BluetoothDevice device) async {
    setState(() {
      _isButtonUnavailable = true;
    });

    if (!isConnected) {
      await BluetoothConnection.toAddress(device.address)
          .then((_connection) {
        print('Connected to ${device.name}');
        connection = _connection;
        setState(() {
          _connected = true;

        });

        connection?.input?.listen(null).onDone(() {
          if (isDisconnecting) {
            print('Disconnecting locally!');
          } else {
            print('Disconnected remotely!');
          }
          if (this.mounted) {
            setState(() {});
          }
        });

        // Navigate to the control page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ControlPage(connection: connection!),
          ),
        );

      }).catchError((error) {
        print('Cannot connect, exception occurred');
        print(error);
      });

      show('Connected to ${device.name}');

      setState(() => _isButtonUnavailable = false);
    }
  }






// Method to connect to bluetooth
  void _connect() async {
    setState(() {
      _isButtonUnavailable = true;
    });
    if (_device == null) {
      show('No device selected');
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(_device?.address)
            .then((_connection) {
          print('Connected to the device');
          connection = _connection;
          setState(() {
            _connected = true;
          });

          connection?.input?.listen(null).onDone(() {
            if (isDisconnecting) {
              print('Disconnecting locally!');
            } else {
              print('Disconnected remotely!');
            }
            if (this.mounted) {
              setState(() {});
            }
          });
        }).catchError((error) {
          print('Cannot connect, exception occurred');
          print(error);
        });
        show('Device connected');

        setState(() => _isButtonUnavailable = false);
      }
    }
  }

// void _onDataReceived(Uint8List data) {
//   // Allocate buffer for parsed data
//   int backspacesCounter = 0;
//   data.forEach((byte) {
//     if (byte == 8 || byte == 127) {
//       backspacesCounter++;
//     }
//   });
//   Uint8List buffer = Uint8List(data.length - backspacesCounter);
//   int bufferIndex = buffer.length;

//   // Apply backspace control character
//   backspacesCounter = 0;
//   for (int i = data.length - 1; i >= 0; i--) {
//     if (data[i] == 8 || data[i] == 127) {
//       backspacesCounter++;
//     } else {
//       if (backspacesCounter > 0) {
//         backspacesCounter--;
//       } else {
//         buffer[--bufferIndex] = data[i];
//       }
//     }
//   }
// }

// Method to disconnect bluetooth
  void _disconnect() async {
    setState(() {
      _isButtonUnavailable = true;
      _deviceState = 0;
    });

    await connection?.close();
    show('Device disconnected');
    if (!connection!.isConnected) {
      setState(() {
        _connected = false;
        _isButtonUnavailable = false;
      });
    }
  }

// Method to send message,
// for turning the Bluetooth device on
  void _sendOnMessageToBluetooth() async {
    connection?.output.add(utf8.encode("F" + "\r\n"));
    await connection?.output.allSent;
    show('Device Turned On');
    setState(() {
      _deviceState = 1; // device on
    });
  }


// Method to send message,
// for turning the Bluetooth device off
  void _sendOffMessageToBluetooth() async {
    connection?.output.add(utf8.encode("S" + "\r\n"));
    await connection?.output.allSent;
    show('Device Turned Off');
    setState(() {
      _deviceState = -1; // device off
    });
  }

// Method to show a Snackbar,
// taking message as the text
  Future show(
      String message, {
        Duration duration: const Duration(seconds: 3),
      }) async {
    await new Future.delayed(new Duration(milliseconds: 100));

    SnackBar(
      content: new Text(
        message,
      ),
      duration: duration,
    );

  }

  void _showConnectDialog(BluetoothDevice device) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white38.withOpacity(0.9), // Transparent background color
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text("Connecting to ${device.name}"),
          content: SizedBox(
            width: 80, // Adjust the width to make it smaller
            height: 80, // Adjust the height to make it smaller
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(device.name.toString()),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
    _connectToDevice(device);
  }
}

