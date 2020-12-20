import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notatinik_wedkarza/common/design.dart';
import 'package:notatinik_wedkarza/models/fishing_entry.dart';
import 'package:notatinik_wedkarza/models/user.dart';
import 'package:notatinik_wedkarza/services/api_social.dart';

class Details extends StatefulWidget {
  final FishingEntry fishingEntry;
  final User userInfo;
  Details({this.fishingEntry, this.userInfo});
  @override
  _DetailsState createState() => _DetailsState(fishingEntry, userInfo);
}

class _DetailsState extends State<Details> with SingleTickerProviderStateMixin {
  final FishingEntry fishingEntry;
  final User userInfo;
  ApiSocial apiSocial = new ApiSocial();
  var image;
  var bytes;
  _DetailsState(this.fishingEntry, this.userInfo);
  @override
  void initState() {
    setState(
      () {
        bytes = base64Decode(fishingEntry.img);
        print(fishingEntry.img);
      },
    );

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
        actions: [
          IconButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                  title: Text("Cz na pewno chcesz udostępnić?"),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FlatButton(
                          onPressed: () async {
                            String content;
                            content = "Moje ostatnie połowy:\n" +
                                "Miejsce: " +
                                fishingEntry.nameOfThePlace +
                                "\n" +
                                "Sposób połowu: " +
                                fishingEntry.methods +
                                "Ryby: " +
                                fishingEntry.fishes;
                            apiSocial.postMessage(userInfo, content, false);
                            Navigator.of(context).pop();
                          },
                          child: Text("Tak"),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Nie"),
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
            icon: Icon(Icons.share),
          )
        ],
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
                  getTextWidget("Woda", getBoldStyle(mainFontSize)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 20),
                      //getTextWidget("Woda: ", getBoldStyle(mainFontSize)),
                      getTextWidget(fishingEntry.nameOfThePlace,
                          getSimplyTextStyle(minorFontSize)),
                    ],
                  ),
                  getDivider(),
                  getTextWidget("Data", getBoldStyle(mainFontSize)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 20),
                      getTextWidget(fishingEntry.dateTime,
                          getSimplyTextStyle(minorFontSize)),
                    ],
                  ),
                  getDivider(),
                  getTextWidget("Opis", getBoldStyle(mainFontSize)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 20),
                      getTextWidget(fishingEntry.description,
                          getSimplyTextStyle(minorFontSize)),
                    ],
                  ),
                  getDivider(),
                  getTextWidget("Metoda", getBoldStyle(mainFontSize)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 20, height: 10),
                      getTextWidget(fishingEntry.methods,
                          getSimplyTextStyle(minorFontSize)),
                    ],
                  ),
                  getDivider(),
                  getTextWidget("Ryby", getBoldStyle(mainFontSize)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 20),
                      getTextWidget(fishingEntry.fishes,
                          getSimplyTextStyle(minorFontSize)),
                    ],
                  ),
                  getDivider(),
                  getTextWidget("Szczegoly", getBoldStyle(mainFontSize)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 20),
                      getTextWidget(fishingEntry.details,
                          getSimplyTextStyle(minorFontSize)),
                    ],
                  ),
                  getDivider(),
                  getTextWidget("Zdjecie", getBoldStyle(mainFontSize)),
                  SizedBox(height: 20),
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
