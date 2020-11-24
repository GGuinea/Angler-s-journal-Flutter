import 'package:flutter/material.dart';

class FishingAreaList extends StatefulWidget {
  @override
  _FishingAreaListState createState() => _FishingAreaListState();
}

class _FishingAreaListState extends State<FishingAreaList> {
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
            colors: [Colors.blue, Colors.white],
          ),
        ),
      ),
    );
  }
}
