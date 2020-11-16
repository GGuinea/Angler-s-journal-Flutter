import 'dart:convert';
import 'package:vector_math/vector_math_64.dart' as vector;

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
          parent: _animationController, curve: Curves.easeInOutCubic))
        ..addListener(() {
          setState(() {});
        });
      //image.writeAsBytesSync(bytes);
    });

    super.initState();
  }

  Animation _animation;
  AnimationController _animationController;
  final double mainFontSize = 20.0;
  final double minorFontSize = 18.0;

  Widget getTextWidget(text, textStyle) {
    return Text(
      text,
      style: textStyle,
    );
  }

  Widget getDivider() {
    return Divider(
      color: Colors.black,
    );
  }

  TextStyle getBoldStyle(size) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle getSimplyTextStyle(size) {
    return TextStyle(
      fontSize: size,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fishingEntry.name),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: gradiendColors,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 20),
                      getTextWidget("Woda: ", getBoldStyle(mainFontSize)),
                      getTextWidget(fishingEntry.nameOfThePlace,
                          getSimplyTextStyle(minorFontSize)),
                    ],
                  ),
                  getDivider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 20),
                      getTextWidget("Czas: ", getBoldStyle(mainFontSize)),
                      getTextWidget(fishingEntry.dateTime,
                          getSimplyTextStyle(minorFontSize)),
                    ],
                  ),
                  getDivider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 20),
                      getTextWidget("Opis: ", getBoldStyle(mainFontSize)),
                      getTextWidget(fishingEntry.description,
                          getSimplyTextStyle(minorFontSize)),
                    ],
                  ),
                  getDivider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 20),
                      getTextWidget("Metoda: ", getBoldStyle(mainFontSize)),
                      getTextWidget(fishingEntry.methods,
                          getSimplyTextStyle(minorFontSize)),
                    ],
                  ),
                  getDivider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 20),
                      getTextWidget("Ryby: ", getBoldStyle(mainFontSize)),
                      getTextWidget(fishingEntry.fishes,
                          getSimplyTextStyle(minorFontSize)),
                    ],
                  ),
                  getDivider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 20),
                      getTextWidget("Szczegoly: ", getBoldStyle(mainFontSize)),
                      getTextWidget(fishingEntry.details,
                          getSimplyTextStyle(minorFontSize)),
                    ],
                  ),
                  getDivider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(width: 20),
                      getTextWidget("Zdjecia: ", getBoldStyle(mainFontSize)),
                      getTextWidget("(Kilknij 2x by powiekszyc)",
                          getSimplyTextStyle(12.0)),
                    ],
                  ),
                  GestureDetector(
                    onDoubleTap: () {
                      if (_animationController.isCompleted) {
                        _animationController.reverse();
                      } else {
                        _animationController.forward();
                      }
                    },
                    child: Transform(
                      alignment: FractionalOffset.topCenter,
                      transform: vector.Matrix4.diagonal3(
                        vector.Vector3(_animation.value / 2,
                            _animation.value / 2, _animation.value / 2),
                      ),
                      child: Image.memory(bytes),
                    ),
                  ),
                  SizedBox(
                    height: 165,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
