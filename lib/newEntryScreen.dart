import 'package:flutter/material.dart';

import 'models/Fish.dart';
import 'views/diary/fishChooser.dart';

class NewEntryScreen extends StatefulWidget {
  @override
  _NewEntryScreenState createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends State<NewEntryScreen> {
  String title = "";
  String waterName = "";
  String description = "";
  String dateStart = "";
  List<String> fishes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dodaj wyprawe"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.white],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                    decoration: InputDecoration(
                      labelText: 'Tytul wyprawy',
                    ),
                    onChanged: (val) {
                      title = val;
                    }),
                TextField(
                    decoration: InputDecoration(
                      labelText: 'Nazwa zbiornika',
                    ),
                    onChanged: (val) {
                      waterName = val;
                    }),
                RaisedButton(
                  onPressed: () async {
                    final result =
                        Navigator.of(context).push(MaterialPageRoute<Fish>(
                      builder: (context) => FishChooser(),
                    ));
                    Fish output = await result;
                    setState(() {
                      fishes.add(output.name + output.size + output.weight);
                    });
                  },
                  child: Text("Dodaj zlowiona rybe"),
                ),
                SizedBox(height: 20),
                fishes != null && fishes.length != 0
                    ? Column(
                        children: fishes.map((data) {
                          return ListTile(
                            title: Text(data),
                          );
                        }).toList(),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
