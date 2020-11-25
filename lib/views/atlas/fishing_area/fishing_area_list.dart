import 'package:NotatnikWedkarza/common/design.dart';
import 'package:NotatnikWedkarza/models/User.dart';
import 'package:NotatnikWedkarza/services/api_service.dart';
import 'package:flutter/material.dart';

class FishingAreaList extends StatefulWidget {
  final User userInfo;
  FishingAreaList({this.userInfo});
  @override
  _FishingAreaListState createState() => _FishingAreaListState(userInfo);
}

class _FishingAreaListState extends State<FishingAreaList> {
  final User userInfo;
  _FishingAreaListState(this.userInfo);
  final ApiService api = ApiService();
  var entries = [];

  void getAllDistricts() async {
    var futureEntries = await api.getDistricts(userInfo);
    entries = new List.from(futureEntries.reversed);
  }

  Future<bool> fetchData() => Future.delayed(Duration(seconds: 1), () {
        initState();
        return true;
      });

  @override
  void initState() {
    getAllDistricts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista lowisk"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.location_searching),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                InkWell(
                                  child: Column(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            entries[index].district,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25),
                                          ),
                                          Text(
                                            "Liczba lowisk: " +
                                                entries[index]
                                                    .areaCounter
                                                    .toString(),
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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
