import 'package:flutter/material.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:notatinik_wedkarza/common/design.dart';
import 'package:notatinik_wedkarza/models/user.dart';
import 'package:notatinik_wedkarza/services/api_service.dart';
import 'package:notatinik_wedkarza/services/api_social.dart';

class MarkerListView extends StatefulWidget {
  final User userInfo;
  MarkerListView({this.userInfo});
  @override
  _MarkerListViewState createState() => _MarkerListViewState(userInfo);
}

class _MarkerListViewState extends State<MarkerListView> {
  _MarkerListViewState(this.userInfo);
  final User userInfo;
  var entries = [];
  final ApiService api = ApiService();
  final ApiSocial apiSocial = ApiSocial();
  Future<bool> fetchData() => Future.delayed(Duration(seconds: 3), () {
        initState();
        return true;
      });

  Future<void> getAllEntres() async {
    var futureEntries = await api.getMarkers(userInfo);
    entries = new List.from(futureEntries.reversed);
  }

  void justForInitState() async {
    await getAllEntres();
  }

  @override
  void initState() {
    justForInitState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Zapisane miejsca"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.centerRight,
            colors: gradiendColors,
          ),
        ),
        child: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: InkWell(
                    onTap: () {
                      print(entries.length);
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
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            (entries.length - index).toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 31),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    entries[index].title,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    entries[index].description,
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                //IconButton(
                                //  onPressed: () {},
                                //  icon: Icon(Icons.share),
                                //),
                                IconButton(
                                  onPressed: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (context) => SimpleDialog(
                                        title:
                                            Text("Czy na pewno chcesz usunąć?"),
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                RaisedButton(
                                                  shape: StadiumBorder(),
                                                  color: Colors.orange[500],
                                                  onPressed: () {
                                                    GeoCoord position =
                                                        GeoCoord(
                                                            entries[index]
                                                                .latitude,
                                                            entries[index]
                                                                .longitude);
                                                    Marker newMarker = Marker(
                                                        position,
                                                        info: entries[index]
                                                            .title,
                                                        infoSnippet:
                                                            entries[index]
                                                                .description);
                                                    api.removeMarker(
                                                        newMarker, userInfo);
                                                    setState(() {
                                                      entries.remove(
                                                          entries[index]);
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Tak"),
                                                ),
                                                RaisedButton(
                                                  shape: StadiumBorder(),
                                                  color: Colors.orange[500],
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Nie"),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: entries.length,
            );
          },
        ),
      ),
    );
  }
}
