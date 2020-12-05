import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notatinik_wedkarza/common/design.dart';
import 'package:notatinik_wedkarza/models/fishing_entry.dart';

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
      bytes = base64Decode(fishingEntry.img);
      print(fishingEntry.img);
    });

    super.initState();
  }

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
                    ],
                  ),
                  InteractiveViewer(
                    minScale: 1,
                    maxScale: 2,
                    child: Image.memory(bytes, height: 300, width: 300),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
