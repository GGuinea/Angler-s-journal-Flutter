import 'dart:convert';
import 'package:vector_math/vector_math_64.dart';

import 'package:NotatnikWedkarza/common/design.dart';
import 'package:NotatnikWedkarza/models/FishingEntry.dart';
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  final FishingEntry fishingEntry;
  Details({this.fishingEntry});
  @override
  _DetailsState createState() => _DetailsState(fishingEntry);
}

class _DetailsState extends State<Details> with SingleTickerProviderStateMixin {
  final FishingEntry fishingEntry;
  var image;
  var bytes;
  _DetailsState(this.fishingEntry);
  @override
  void initState() {
    setState(() {
      //image = Io.File('imageFromDiary.jpg');
      bytes = base64Decode(fishingEntry.img);
      print(fishingEntry.img);
      _animationController = new AnimationController(
          vsync: this, duration: Duration(milliseconds: 500));
      _animation = Tween(begin: 1.0, end: 3.0).animate(CurvedAnimation(
          parent: _animationController, curve: Curves.easeInOut))
        ..addListener(() {
          setState(() {});
        });
      //image.writeAsBytesSync(bytes);
    });

    super.initState();
  }

  Animation _animation;
  AnimationController _animationController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: gradiendColors,
            ),
          ),
          child: GestureDetector(
              onDoubleTap: () {
                if (_animationController.isCompleted) {
                  _animationController.reverse();
                } else {
                  _animationController.forward();
                }
              },
              child: Transform(
                  alignment: FractionalOffset.center,
                  transform: Matrix4.diagonal3(Vector3(_animation.value / 2,
                      _animation.value / 2, _animation.value / 2)),
                  child: Image.memory(bytes)))),
    );
  }
}
