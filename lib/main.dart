import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:led_rgb_arduino/screens/scan_screen.dart';

import 'screens/bluetooth_off_screen.dart';
import 'screens/picker_screen.dart';

void main() {
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  runApp(const FlutterBlueApp());
}

//
// This widget shows BluetoothOffScreen or
// ScanScreen depending on the adapter state
//
class FlutterBlueApp extends StatefulWidget {
  const FlutterBlueApp({Key? key}) : super(key: key);

  @override
  State<FlutterBlueApp> createState() => _FlutterBlueAppState();
}

class _FlutterBlueAppState extends State<FlutterBlueApp> {
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  @override
  void initState() {
    super.initState();
    _adapterStateStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _adapterStateStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget screen = _adapterState == BluetoothAdapterState.on
        ? const ScanScreen()
        : BluetoothOffScreen(adapterState: _adapterState);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: const Color.fromRGBO(26, 26, 26, 1),
      home: screen,
      navigatorObservers: [BluetoothAdapterStateObserver()],
    );
  }
}

//
// This observer listens for Bluetooth Off and dismisses the DeviceScreen
//
class BluetoothAdapterStateObserver extends NavigatorObserver {
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name == '/DeviceScreen') {
      // Start listening to Bluetooth state changes when a new route is pushed
      _adapterStateSubscription ??= FlutterBluePlus.adapterState.listen((state) {
        if (state != BluetoothAdapterState.on) {
          // Pop the current route if Bluetooth is off
          navigator?.pop();
        }
      });
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    // Cancel the subscription when the route is popped
    _adapterStateSubscription?.cancel();
    _adapterStateSubscription = null;
  }
}


// import 'dart:async';
// import 'dart:convert' show utf8;

// // import 'package:control_pad/control_pad.dart';
// // import 'package:control_pad/models/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_blue/flutter_blue.dart';

// void main() {
//   runApp(MainScreen());
// }

// class MainScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Joypad with BLE',
//       debugShowCheckedModeBanner: false,
//       home: Test(),
//       theme: ThemeData.dark(),
//     );
//   }
// }

// class Test extends StatefulWidget {
//   @override
//   _TestState createState() => _TestState();
// }

// class _TestState extends State<Test> {
//   final String SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
//   final String CHARACTERISTIC_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
//   final String TARGET_DEVICE_NAME = "ESP32 GET NOTI FROM DEVICE";

//   FlutterBlue flutterBlue = FlutterBlue.instance;

//   late StreamSubscription<ScanResult> scanSubScription;
//   late BluetoothDevice targetDevice;
//   BluetoothCharacteristic? targetCharacteristic;

//   String connectionText = "";

//   @override
//   void initState() {
//     super.initState();
//     startScan();
//   }

//   startScan() {
//     setState(() {
//       connectionText = "Escaneando...";
//     });

//     scanSubScription = flutterBlue.scan().listen((scanResult) {
//       print(scanResult.device.name);
//       if (scanResult.device.name == TARGET_DEVICE_NAME) {
//         print('DEVICE found');
//         stopScan();
//         setState(() {
//           connectionText = "Found Target Device";
//         });

//         targetDevice = scanResult.device;
//         connectToDevice();
//       }
//     }, onDone: () => stopScan());
//   }

//   stopScan() {
//     scanSubScription.cancel();
//     //scanSubScription = null;
//   }

//   connectToDevice() async {
//     if (targetDevice == null) return;

//     setState(() {
//       connectionText = "Device Connecting";
//     });

//     await targetDevice.connect();
//     print('DEVICE CONNECTED');
//     setState(() {
//       connectionText = "Device Connected";
//     });

//     discoverServices();
//   }

//   disconnectFromDevice() {
//     if (targetDevice == null) return;

//     targetDevice.disconnect();

//     setState(() {
//       connectionText = "Device Disconnected";
//     });
//   }

//   discoverServices() async {
//     if (targetDevice == null) return;

//     List<BluetoothService> services = await targetDevice.discoverServices();
//     for (var service in services) {
//       // do something with service
//       if (service.uuid.toString() == SERVICE_UUID) {
//         for (var characteristic in service.characteristics) {
//           if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
//             targetCharacteristic = characteristic;
//             writeData("Hi there, ESP32!!");
//             setState(() {
//               connectionText = "All Ready with ${targetDevice.name}";
//             });
//           }
//         }
//       }
//     }
//   }

//   writeData(String data) async {
//     if (targetCharacteristic == null) return;

//     List<int> bytes = utf8.encode(data);
//     await targetCharacteristic?.write(bytes);
//   }

//   // --------------------------------------------------------
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(connectionText),
//       ),
//       body: Container(
//         child: targetCharacteristic == null
//             ? Center(
//                 child: Text(
//                   "Waiting...",
//                   style: TextStyle(fontSize: 24, color: Colors.red),
//                 ),
//               )
//             : Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   TextButton(
//                     onPressed: () => {
//                       writeData("Este es el boton 1")
//                     }, 
//                     child: Text('Send data to ESP32')
//                   )
//                 ],
//               ),
//       ),
//     );
//   }
// }

// // class JoyPad extends StatefulWidget {
// //   @override
// //   _JoyPadState createState() => _JoyPadState();
// // }

// // class _JoyPadState extends State<JoyPad> {
// //   final String SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
// //   final String CHARACTERISTIC_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
// //   final String TARGET_DEVICE_NAME = "ESP32 GET NOTI FROM DEVICE";

// //   FlutterBlue flutterBlue = FlutterBlue.instance;
// //   StreamSubscription<ScanResult> scanSubScription;

// //   BluetoothDevice targetDevice;
// //   BluetoothCharacteristic targetCharacteristic;

// //   String connectionText = "";

// //   @override
// //   void initState() {
// //     super.initState();
// //     startScan();
// //   }

// //   startScan() {
// //     setState(() {
// //       connectionText = "Start Scanning";
// //     });

// //     scanSubScription = flutterBlue.scan().listen((scanResult) {
// //       if (scanResult.device.name == TARGET_DEVICE_NAME) {
// //         print('DEVICE found');
// //         stopScan();
// //         setState(() {
// //           connectionText = "Found Target Device";
// //         });

// //         targetDevice = scanResult.device;
// //         connectToDevice();
// //       }
// //     }, onDone: () => stopScan());
// //   }

// //   stopScan() {
// //     scanSubScription?.cancel();
// //     scanSubScription = null;
// //   }

// //   connectToDevice() async {
// //     if (targetDevice == null) return;

// //     setState(() {
// //       connectionText = "Device Connecting";
// //     });

// //     await targetDevice.connect();
// //     print('DEVICE CONNECTED');
// //     setState(() {
// //       connectionText = "Device Connected";
// //     });

// //     discoverServices();
// //   }

// //   disconnectFromDevice() {
// //     if (targetDevice == null) return;

// //     targetDevice.disconnect();

// //     setState(() {
// //       connectionText = "Device Disconnected";
// //     });
// //   }

// //   discoverServices() async {
// //     if (targetDevice == null) return;

// //     List<BluetoothService> services = await targetDevice.discoverServices();
// //     services.forEach((service) {
// //       // do something with service
// //       if (service.uuid.toString() == SERVICE_UUID) {
// //         service.characteristics.forEach((characteristic) {
// //           if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
// //             targetCharacteristic = characteristic;
// //             writeData("Hi there, ESP32!!");
// //             setState(() {
// //               connectionText = "All Ready with ${targetDevice.name}";
// //             });
// //           }
// //         });
// //       }
// //     });
// //   }

// //   writeData(String data) async {
// //     if (targetCharacteristic == null) return;

// //     List<int> bytes = utf8.encode(data);
// //     await targetCharacteristic.write(bytes);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     JoystickDirectionCallback onDirectionChanged(
// //         double degrees, double distance) {
// //       String data =
// //           "Degree : ${degrees.toStringAsFixed(2)}, distance : ${distance.toStringAsFixed(2)}";
// //       print(data);
// //       writeData(data);
// //     }

// //     PadButtonPressedCallback padBUttonPressedCallback(
// //         int buttonIndex, Gestures gesture) {
// //       String data = "buttonIndex : ${buttonIndex}";
// //       print(data);
// //       writeData(data);
// //     }

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(connectionText),
// //       ),
// //       body: Container(
// //         child: targetCharacteristic == null
// //             ? Center(
// //                 child: Text(
// //                   "Waiting...",
// //                   style: TextStyle(fontSize: 24, color: Colors.red),
// //                 ),
// //               )
// //             : Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                 children: <Widget>[
// //                   JoystickView(
// //                     onDirectionChanged: onDirectionChanged,
// //                   ),
// //                   PadButtonsView(
// //                     padButtonPressedCallback: padBUttonPressedCallback,
// //                   ),
// //                 ],
// //               ),
// //       ),
// //     );
// //   }
// // }