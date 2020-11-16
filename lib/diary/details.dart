import 'dart:convert';

import 'package:NotatnikWedkarza/models/FishingEntry.dart';
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  final FishingEntry fishingEntry;
  Details({this.fishingEntry});
  @override
  _DetailsState createState() => _DetailsState(fishingEntry);
}

class _DetailsState extends State<Details> {
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
      //image.writeAsBytesSync(bytes);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Image.memory(bytes),
      ),
    );
  }
}
