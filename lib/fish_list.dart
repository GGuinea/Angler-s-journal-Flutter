import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'package:notatinik_wedkarza/models/static_fish_atlas.dart';
import 'package:notatinik_wedkarza/views/card_description.dart';

class FishList extends StatefulWidget {
  @override
  _FishListState createState() => _FishListState();
}

class _FishListState extends State<FishList> {
  Future<List<GetFishes>> fetchJSONData() async {
    var json = rootBundle.loadString('assets/data.json');
    String jsonStr = await json;
    final jsonItems = jsonDecode(jsonStr).cast<Map<String, dynamic>>();
    List<GetFishes> fishList = jsonItems.map<GetFishes>((jsonStr) {
      return GetFishes.fromJson(jsonStr);
    }).toList();
    return fishList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Atlas ryb"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.white],
          ),
        ),
        child: FutureBuilder(
            future:
                DefaultAssetBundle.of(context).loadString('assets/data.json'),
            builder: (context, snapshot) {
              var newData = jsonDecode(snapshot.data.toString());
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CardDescription(
                                name: newData[index]['name'],
                                desc: newData[index]['desc'],
                                img: newData[index]['img']),
                          ));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 22, bottom: 22, left: 16, right: 16),
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
                                Container(
                                    height: 150,
                                    width: 150,
                                    child: Image.asset(
                                        'assets/' + newData[index]['img']))
                              ],
                            ),
                          ),
                        ),
                      ));
                },
                itemCount: newData == null ? 0 : newData.length,
              );
            }),
      ),
    );
  }
}
