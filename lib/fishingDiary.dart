import 'package:NotatnikWedkarza/common/design.dart';
import 'package:flutter/material.dart';

import 'diary/details.dart';
import 'models/User.dart';
import 'newEntryScreen.dart';
import 'services/api_service.dart';

class Diary extends StatefulWidget {
  final User userInfo;
  Diary({this.userInfo});
  @override
  _DiaryState createState() => _DiaryState(userInfo);
}

class _DiaryState extends State<Diary> {
  final User userInfo;
  _DiaryState(this.userInfo);
  final dateControllerStart = TextEditingController();
  String title = "";
  String waterName = "";
  String description = "";
  String dateStart = "";
  final ApiService api = ApiService();
  var entries = [];

  @override
  void dispose() {
    dateControllerStart.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getAllEntres();
    super.initState();
  }

  void getAllEntres() async {
    var futureEntries = await api.getEntries(userInfo);
    entries = new List.from(futureEntries.reversed);
  }

  Future<bool> fetchData() => Future.delayed(Duration(seconds: 3), () {
        initState();
        return true;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      Navigator.of(context).push(
                        new MaterialPageRoute(
                          builder: (context) =>
                              Details(fishingEntry: entries[index]),
                        ),
                      );
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
                                          Text(
                                            entries[index].name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => NewEntryScreen(userInfo: userInfo),
          ));
        },
        backgroundColor: Colors.orange[500],
        splashColor: Colors.purple[500],
        child: Icon(
          Icons.add,
          color: Colors.blue,
          size: 20,
        ),
      ),
    );
  }
}
