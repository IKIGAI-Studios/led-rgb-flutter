import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';

class ColorPicker extends StatefulWidget {
  const ColorPicker();

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  Color _currentColor = Colors.blue;
  Color _previousColor = Colors.black;
  var _switchValue = false;

  final _controller = CircleColorPickerController(
    initialColor: Colors.blue,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(26, 26, 26, 1),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Icon(
                Icons.lightbulb_outline,
                color: _currentColor,
                size: 100,
              )
            ),
            const SizedBox(height: 48),
            Center(
              child: CircleColorPicker(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                controller: _controller,
                onChanged: (color) {
                  setState(() => {
                    _currentColor = color,
                    // Send color to the device

                    
                    print(_controller.color)
                  });
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
                          _controller.color = Color.fromRGBO(value.toInt(), _currentColor.green, _currentColor.blue, 1);
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
                          _controller.color = Color.fromRGBO(_currentColor.red, value.toInt(), _currentColor.blue, 1);
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
                          _controller.color = Color.fromRGBO(_currentColor.red, _currentColor.green, value.toInt(), 1);
                        });
                      },
                    ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_switchValue ? 'Apagar' : 'Encender', style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    Switch(
                      value: _switchValue,
                      onChanged: (value) {
                        setState(() {
                          _switchValue = value;
                          _previousColor = _currentColor;
                          _controller.color = _switchValue ? Colors.black : _previousColor;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
    );
  }
}