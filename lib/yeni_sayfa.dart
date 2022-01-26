import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

class YeniSayfa extends StatefulWidget {
  const YeniSayfa({Key? key}) : super(key: key);

  @override
  _YeniSayfaState createState() => _YeniSayfaState();
}

class _YeniSayfaState extends State<YeniSayfa>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  SequenceAnimation? sequenceAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
    );
    sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
            animatable: Tween<double>(begin: 0, end: 1),
            from: Duration.zero,
            to: Duration(seconds: 1),
            tag: "opacity")
        .addAnimatable(
            animatable: Tween<double>(begin: 50, end: 150),
            from: Duration(seconds: 2),
            to: Duration(seconds: 4),
            tag: "width")
        .addAnimatable(
            animatable: Tween<double>(begin: 0, end: 300),
            from: Duration(seconds: 1),
            to: Duration(seconds: 2),
            tag: "yukseklik")
        .addAnimatable(
            animatable: EdgeInsetsTween(
                begin: EdgeInsets.only(bottom: 16),
                end: EdgeInsets.only(bottom: 75)),
            from: Duration(seconds: 0),
            to: Duration(seconds: 2),
            curve: Curves.easeIn,
            tag: "edge")
        .addAnimatable(
            animatable:
                ColorTween(begin: Colors.blue[100], end: Colors.blue[600]),
            from: Duration(seconds: 2),
            to: Duration(seconds: 4),
            tag: "colors")
        .addAnimatable(
            animatable: BorderRadiusTween(
                begin: BorderRadius.circular(0.8),
                end: BorderRadius.circular(100)),
            from: Duration(seconds: 2),
            to: Duration(seconds: 3),
            tag: "radius")
        .animate(controller); //Opacity Animation

    controller!.forward();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yeni Sayfa"),
      ),
      body: Center(
        child: AnimatedBuilder(
            animation: controller!,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                    color: sequenceAnimation!["colors"].value,
                    border: Border.all(color: Colors.blue),
                    borderRadius: sequenceAnimation!["radius"].value),
                padding: sequenceAnimation!["edge"].value,
                child: Opacity(
                  opacity: sequenceAnimation!["opacity"].value,
                  child: Container(
                    width: sequenceAnimation!["width"].value,
                    height: sequenceAnimation!["yukseklik"].value,
                  ),
                ),
              );
            }),
      ),
    );
  }
}
