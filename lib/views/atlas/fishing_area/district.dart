import 'package:NotatnikWedkarza/common/design.dart';
import 'package:NotatnikWedkarza/models/user.dart';
import 'package:NotatnikWedkarza/services/api_service.dart';
import 'package:NotatnikWedkarza/views/atlas/fishing_area/fishing_area_details.dart';
import 'package:flutter/material.dart';

class District extends StatefulWidget {
  final User userInfo;
  final String district;
  District({this.userInfo, this.district});
  @override
  _DistrictState createState() => _DistrictState(userInfo, district);
}

class _DistrictState extends State<District> {
  final User userInfo;
  final String district;
  _DistrictState(this.userInfo, this.district);
  final ApiService api = ApiService();
  var entries = [];

  void getEntriesFromDistricts() async {
    entries = await api.getAreasFromDistict(userInfo, district);
    //entries = new List.from(futureEntries);
  }

  Future<bool> fetchData() => Future.delayed(Duration(seconds: 1), () {
        initState();
        return true;
      });

  @override
  void initState() {
    getEntriesFromDistricts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          district,
        ),
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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FishingAreaDetails(
                            userInfo: userInfo,
                            fishingArea: entries[index],
                          ),
                        ),
                      );
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
                                            entries[index].name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25),
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
