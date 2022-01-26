import 'package:flutter/material.dart';
import 'package:flutter_firebase/transform_anim.dart';

class AnimasyonWdigetler extends StatefulWidget {
  const AnimasyonWdigetler({Key? key}) : super(key: key);

  @override
  _AnimasyonWdigetlerState createState() => _AnimasyonWdigetlerState();
}

class _AnimasyonWdigetlerState extends State<AnimasyonWdigetler> {
  Color? _color = Colors.lightGreenAccent;
  var _height = 200.0;
  var _width = 200.0;
  var _ilkcocukAktif = false;
  var _opacity = 1.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("~~~Animasyon Widget'ları~~~"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AnimatedContainer(
                height: _height,
                width: _width,
                duration: Duration(seconds: 2),
                color: _color,
              ),
              AnimatedCrossFade(
                  firstChild: Image.network(
                      "https://c.tenor.com/z6AiQykyqvgAAAAM/dorime-rat-rat.gif"),
                  secondChild: Image.network(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSN2_5z55OLcth-2XFBsNwJHtPMAiWWLMWMTw&usqp=CAU.jpeg"),
                  crossFadeState: _ilkcocukAktif
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: Duration(seconds: 2)),
              AnimatedOpacity(
                opacity: _opacity,
                duration: Duration(
                  seconds: 1,
                ),
                child: Text("Cevaplar : 1:A 2:B 3:A 4:C "),
              ),
              ElevatedButton(
                onPressed: () {
                  _animatedContainerAnim();
                },
                child: Text("Animated Container"),
                style: ElevatedButton.styleFrom(onPrimary: Colors.limeAccent),
              ),
              ElevatedButton(
                onPressed: () {
                  _crossFadeAnim();
                },
                child: Text("CrossFade Anim"),
                style: ElevatedButton.styleFrom(onPrimary: Colors.purple[700]),
              ),
              ElevatedButton(
                onPressed: () {
                  _opacityAnim();
                },
                child: Text("Opacity Anim"),
                style: ElevatedButton.styleFrom(onPrimary: Colors.purple[700]),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TransformWidgetAnim()));
                },
                child: Text("Transform Page"),
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _animatedContainerAnim() {
    setState(() {
      _color = _color == Colors.lightGreenAccent
          ? Colors.red[300]
          : Colors.purple[400];
      _height = _height == 200.0 ? 10.2 : 300.1;
      _width = _width == 200.0 ? 300 : 150.0;
    });
  }

  void _crossFadeAnim() {
    setState(() {
      _ilkcocukAktif = !_ilkcocukAktif;
    });
  }

  void _opacityAnim() {
    setState(() {
      if (_opacity == 1.0) {
        _opacity = 0;
      } else {
        _opacity = 1.0;
      }
    });
  }
}
