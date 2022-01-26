import 'package:flutter/material.dart';

class TransformWidgetAnim extends StatefulWidget {
  const TransformWidgetAnim({Key? key}) : super(key: key);

  @override
  _TransformWidgetAnimState createState() => _TransformWidgetAnimState();
}

class _TransformWidgetAnimState extends State<TransformWidgetAnim> {
  var _sliderDegeri = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TransForm Widget"),
      ),
      body: Column(
        children: [
          getSlider(),
          getRotate(),
        ],
      ),
    );
  }

  getSlider() {
    return Slider(
      min: 0,
      max: 100,
      value: _sliderDegeri,
      onChanged: (yeniDeger) {
        setState(() {
          _sliderDegeri = yeniDeger;
        });
      },
    );
  }

  getRotate() {
    return Container(
      child: Transform.rotate(
        angle: _sliderDegeri,
        child: Container(
          height: 100,
          width: 100,
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}
