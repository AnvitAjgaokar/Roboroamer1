// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
//
// class BluetoothDeviceListEntry extends StatelessWidget {
//   final Function onTap;
//   final BluetoothDevice device;
//
//   BluetoothDeviceListEntry({required this.device,required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//
//       leading: Icon(Icons.devices),
//       title: Text(device.name ?? "Unknown device"),
//       subtitle: Text(device.address.toString()),
//       trailing: ElevatedButton(
//         child: Text('Connect'),
//         onPressed:() => onTap,
//
//       ),
//     );
//   }
// }
//
//
//
//
//
