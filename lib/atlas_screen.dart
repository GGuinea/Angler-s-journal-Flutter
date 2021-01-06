import 'package:flutter/material.dart';
import 'package:notatinik_wedkarza/common/design.dart';
import 'package:notatinik_wedkarza/fish_list.dart';
import 'package:notatinik_wedkarza/models/user.dart';
import 'package:notatinik_wedkarza/placeholder_widget.dart';
import 'dart:convert';

import 'package:notatinik_wedkarza/views/atlas/fishing_area/fishing_area_list.dart';
import 'package:notatinik_wedkarza/views/maps/map_screen.dart';

class AtlasScreen extends StatefulWidget {
  final User userInfo;
  AtlasScreen({this.userInfo});
  @override
  _AtlasScreenState createState() => _AtlasScreenState(userInfo);
}

class _AtlasScreenState extends State<AtlasScreen> {
  final User userInfo;
  _AtlasScreenState(this.userInfo);
  final List<Widget> listOfElements = [
    FishList(),
    FishingAreaList(),
    PlaceholderWidget(Colors.red, "regulaminy"),
    //FishingMap()
    MapScreen()
  ];

  @override
  Widget build(BuildContext context) {
    listOfElements[1] = FishingAreaList(userInfo: userInfo);
    //listOfElements[3] = FishingMap(userInfo: userInfo);
    listOfElements[3] = MapScreen(userInfo: userInfo);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.bottomLeft,
            colors: gradiendColors,
          ),
        ),
        child: FutureBuilder(
            future:
                DefaultAssetBundle.of(context).loadString('assets/atlas.json'),
            builder: (context, snapshot) {
              var newData = jsonDecode(snapshot.data.toString());
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  listOfElements[newData[index]['index'] - 1]),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 32, bottom: 32, left: 16, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    child: Text(
                                      newData[index]['name'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: newData == null ? 0 : newData.length,
              );
            }),
      ),
    );
  }
}
