import 'dart:convert';

import 'package:NotatnikWedkarza/models/Fish.dart';
import 'package:NotatnikWedkarza/models/StaticFishAtlas.dart';
import 'package:NotatnikWedkarza/views/diary/details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FishChooser extends StatefulWidget {
  @override
  _FishChooserState createState() => _FishChooserState();
}

class _FishChooserState extends State<FishChooser> {
  TextEditingController _textController = TextEditingController();
  TextEditingController _sizeController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  Future<List<String>> fetchJSONData() async {
    var json = rootBundle.loadString('assets/data.json');
    String jsonStr = await json;
    final jsonItems = jsonDecode(jsonStr).cast<Map<String, dynamic>>();
    List<GetFishes> fishList = jsonItems.map<GetFishes>((jsonStr) {
      return GetFishes.fromJson(jsonStr);
    }).toList();
    List<String> fishNames = [];
    for (var i in fishList) {
      fishNames.add(i.name);
    }
    return fishNames;
  }

  List<String> _newData = [];
  List<String> _staticData = [];
  String size = "";
  String weight = "";
  String fish = "";

  void getNames() async {
    _staticData = await fetchJSONData();
  }

  _onChanged(String value) {
    setState(() {
      _newData = _staticData
          .where((string) => string.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  _onChangedSize(String value) {
    setState(() {
      size = value;
    });
  }

  _onChangedWeight(String value) {
    setState(() {
      weight = value;
    });
  }

  Future<void> _askedToLead() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Uzupelnij informacje'),
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: "rozmiar [cm]",
                        ),
                        controller: _sizeController,
                        onChanged: _onChangedSize,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "waga [kg]",
                        ),
                        controller: _weightController,
                        onChanged: _onChangedWeight,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RaisedButton(
                            color: Colors.orange[300],
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Dodaj",
                            ),
                          ),
                          RaisedButton(
                            color: Colors.red[300],
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Anuluj",
                            ),
                          )
                        ],
                      )
                    ],
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    getNames();
    return Scaffold(
      appBar: AppBar(
        title: Text("Wybierz rybe"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.white],
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: "Wyszukaj",
                ),
                onChanged: _onChanged,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            _newData != null && _newData.length != 0
                ? Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(10),
                      children: _newData.map((data) {
                        return ListTile(
                          onTap: () async {
                            await _askedToLead();
                            Fish fish = new Fish(
                                name: data, size: size, weight: weight);
                            Navigator.of(context).pop(fish);
                          },
                          title: Text(data),
                        );
                      }).toList(),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
