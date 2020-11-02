import 'package:flutter/material.dart';
import 'dart:convert';
import 'fishList.dart';

class AtlasScreen extends StatefulWidget {
  @override
  _AtlasScreenState createState() => _AtlasScreenState();
}

final List<Widget> listOfElements = [FishList()];

class _AtlasScreenState extends State<AtlasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.bottomLeft,
          colors: [Colors.blue, Colors.white],
        )),
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  listOfElements[newData[index]['index'] - 1]));
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
                      ));
                },
                itemCount: newData == null ? 0 : newData.length,
              );
            }),
      ),
    );
  }
}
