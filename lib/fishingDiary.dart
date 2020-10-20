import 'package:flutter/material.dart';
import 'models/FishingEntry.dart';
import 'FishingCart.dart';

class Diary extends StatefulWidget {
  @override
  _DiaryState createState() => _DiaryState();
}

class _DiaryState extends State<Diary> {
  List<FishingEntry> fishingEntries = [
    FishingEntry("Polowy", "assets/images/fish.png", "Nawet spoko",
        "Zalew slok", "data"),
    FishingEntry("Wypad z ziomkiem", "assets/images/fish.png", "Nawet spoko",
        "Zalew wawrzkowizna", "data1"),
    FishingEntry(
        "Polowy samemu", "assets/images/fish.png", "slabo", "ZPT", "data3"),
  ];

  void onTabTapped() {
    print("Debug message");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: 39, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: fishingEntries.length,
                  itemBuilder: (context, index) => ListTile(
                    title: FishingCard(fishingEntry: fishingEntries[index]),
                    onTap: onTabTapped,
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.grey,
            splashColor: Colors.blue,
            onPressed: () {},
            child: Icon(
              Icons.add,
              color: Colors.blue,
              size: 30,
            )));
  }
}
