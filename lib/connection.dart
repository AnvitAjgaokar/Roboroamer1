// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:arduinocar1/device.dart';
//
// import 'led.dart';
//
// class SelectBondedDevicePage extends StatefulWidget {
//   final bool checkAvailability;
//   final Function onCahtPage;
//
//   const SelectBondedDevicePage({
//     this.checkAvailability = true,
//     required this.onCahtPage,
//   });
//
//   @override
//   _SelectBondedDevicePage createState() => _SelectBondedDevicePage();
// }
//
// enum _DeviceAvailability {
//   no,
//   maybe,
//   yes,
// }
//
// class _DeviceWithAvailability {
//   BluetoothDevice device;
//   _DeviceAvailability availability;
//
//   _DeviceWithAvailability(this.device, this.availability);
// }
//
// class _SelectBondedDevicePage extends State<SelectBondedDevicePage> {
//   List<_DeviceWithAvailability> devices = List<_DeviceWithAvailability>.empty();
//   StreamSubscription<BluetoothDiscoveryResult>? _discoveryStreamSubscription;
//   bool _isDiscovering = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _isDiscovering = widget.checkAvailability;
//
//     if (_isDiscovering) {
//       _startDiscovery();
//     }
//
//     FlutterBluetoothSerial.instance
//         .getBondedDevices()
//         .then((List<BluetoothDevice> bondedDevices) {
//       setState(() {
//         devices = bondedDevices
//             .map(
//               (device) => _DeviceWithAvailability(
//             device,
//             widget.checkAvailability
//                 ? _DeviceAvailability.maybe
//                 : _DeviceAvailability.yes,
//           ),
//         )
//             .toList();
//       });
//     });
//   }
//
//   void _restartDiscovery() {
//     setState(() {
//       _isDiscovering = true;
//     });
//
//     _startDiscovery();
//   }
//
//   void _startDiscovery() {
//     _discoveryStreamSubscription =
//         FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
//           setState(() {
//             Iterator i = devices.iterator;
//             while (i.moveNext()) {
//               var _device = i.current;
//               if (_device.device.address == r.device.address) {
//                 _device.availability = _DeviceAvailability.yes;
//               }
//             }
//           });
//         }, onDone: () {
//           setState(() {
//             _isDiscovering = false;
//           });
//         });
//   }
//
//   @override
//   void dispose() {
//     _discoveryStreamSubscription?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List<BluetoothDeviceListEntry> list = devices
//         .map(
//           (_device) => BluetoothDeviceListEntry(
//         device: _device.device,
//         onTap: () {
//           widget.onCahtPage(_device.device);
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) {
//                 return ChatPage(server: _device.device);
//               },
//             ),
//           );
//
//         },
//       ),
//     )
//         .toList();
//     return ListView(
//       children: list,
//     );
//   }
// }
