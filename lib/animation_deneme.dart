import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_firebase/animasyon_widget.dart';
import 'package:flutter_firebase/yeni_sayfa.dart';

class AnimationDeneme extends StatefulWidget {
  const AnimationDeneme({Key? key}) : super(key: key);

  @override
  _AnimationDenemeState createState() => _AnimationDenemeState();
}

class _AnimationDenemeState extends State<AnimationDeneme>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation? animation;
  Animation? animation2;
  Animation? animation3;

  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    animation =
        ColorTween(begin: Colors.red, end: Colors.blue).animate(_controller!);
    animation2 = AlignmentTween(begin: Alignment(-1, -1), end: Alignment.center)
        .animate(_controller!);
    animation3 =
        CurvedAnimation(parent: _controller!, curve: Curves.bounceInOut);

    _controller!.addListener(() {
      setState(() {
        debugPrint("Value : " + _controller!.value.toString());
      });
    });
    _controller!.forward();
    //_controller!.repeat();
  }

  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Animasyon Deneme"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "FLutter Animation",
              style: TextStyle(fontSize: animation3!.value * 36),
            ),
            Hero(
              tag: "uniq",
              child: Container(
                alignment: animation2!.value,
                child: FlutterLogo(
                  size: 64,
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => YeniSayfa()));
                },
                child: Text(
                  "Next Page",
                  style: TextStyle(fontSize: 15),
                )),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AnimasyonWdigetler()));
                },
                child: Text(
                  "Animation Page",
                  style: TextStyle(fontSize: 15),
                )),
          ],
        ),
      ),
    );
  }
}
