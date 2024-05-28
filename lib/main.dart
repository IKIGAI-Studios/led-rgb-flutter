import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

// class Bluetooth extends StatefulWidget {
//   @override
//   _BluetoothState createState() => _BluetoothState();
// }

class _MyAppState extends State<MyApp> {
  Color _currentColor = Colors.blue;
  var _switchValue = false;
  final _controller = CircleColorPickerController(
    initialColor: Colors.blue,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromRGBO(26, 26, 26, 1),
        appBar: AppBar(
          title: const Text(
            'RBG LED App',
            style: TextStyle(
                color: Color.fromRGBO(217, 217, 217, 1),
                fontWeight: FontWeight
                    .bold), // Aquí puedes cambiar el color de la fuente
          ),
          backgroundColor: Color.fromRGBO(26, 26, 26, 1),
          centerTitle: true,
          // Agregar dropdown para seleccionar el dispositivo bluetooth
          actions: <Widget>[
            DropdownButton(
              icon: Icon(Icons.bluetooth),
              items: [
                DropdownMenuItem(
                  child: Text('Dispositivo 1'),
                  value: 1,
                ),
              ],
              onChanged: (value) {
                print(value);
                // conectar a ese dispositivo
              },
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
                child: Icon(
              Icons.lightbulb_outline,
              color: _currentColor,
              size: 100,
            )),
            const SizedBox(height: 48),
            Center(
              child: CircleColorPicker(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                controller: _controller,
                onChanged: (color) {
                  setState(() => _currentColor = color);
                },
              ),
            ),
            const SizedBox(height: 48),
            Column(
              children: [
                // Sliders para cada color
                Slider(
                  value: _currentColor.red.toDouble(),
                  min: 0,
                  max: 255,
                  thumbColor: Colors.red,
                  activeColor: Colors.red,
                  onChanged: (value) {
                    setState(() {
                      _controller.color = Color.fromRGBO(value.toInt(),
                          _currentColor.green, _currentColor.blue, 1);
                    });
                  },
                ),
                Slider(
                  value: _currentColor.green.toDouble(),
                  min: 0,
                  max: 255,
                  thumbColor: Colors.green,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    setState(() {
                      _controller.color = Color.fromRGBO(_currentColor.red,
                          value.toInt(), _currentColor.blue, 1);
                    });
                  },
                ),
                Slider(
                  value: _currentColor.blue.toDouble(),
                  min: 0,
                  max: 255,
                  thumbColor: Colors.blue,
                  activeColor: Colors.blue,
                  onChanged: (value) {
                    setState(() {
                      _controller.color = Color.fromRGBO(_currentColor.red,
                          _currentColor.green, value.toInt(), 1);
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_switchValue ? 'Apagar' : 'Encender',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    Switch(
                      value: _switchValue,
                      onChanged: (value) {
                        setState(() {
                          _switchValue = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
