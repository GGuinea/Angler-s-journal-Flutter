import 'package:NotatnikWedkarza/common/design.dart';
import 'package:NotatnikWedkarza/models/User.dart';
import 'package:NotatnikWedkarza/models/fishing_area.dart';
import 'package:flutter/material.dart';

class FishingAreaDetails extends StatefulWidget {
  final User userInfo;
  final FishingArea fishingArea;
  FishingAreaDetails({this.userInfo, this.fishingArea});
  @override
  _FishingAreaDetailsState createState() =>
      _FishingAreaDetailsState(userInfo, fishingArea);
}

class _FishingAreaDetailsState extends State<FishingAreaDetails> {
  final User userInfo;
  FishingArea fishingArea;
  _FishingAreaDetailsState(this.userInfo, this.fishingArea);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fishingArea.name),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.bottomLeft,
            colors: gradiendColors,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            children: [
              Center(
                child: Text(
                  "OPIS",
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                fishingArea.description,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Montserrat-Medium',
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "KOMENTARZE",
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: fishingArea.comments.length,
                    itemBuilder: (context, index) {
                      return new Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(10),
                            top: Radius.circular(2),
                          ),
                        ),
                        child: Text(
                          fishingArea.comments[index].posterName,
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
