import 'dart:convert';

import 'package:NotatnikWedkarza/models/FishingMethod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MethodChooser extends StatefulWidget {
  @override
  _MethodChooserState createState() => _MethodChooserState();
}

class _MethodChooserState extends State<MethodChooser> {
  Future<List<String>> fetchJSONData() async {
    var json = rootBundle.loadString('assets/fishingMethods.json');
    String jsonStr = await json;
    final jsonItems = jsonDecode(jsonStr).cast<Map<String, dynamic>>();
    List<FishingMethod> fishList = jsonItems.map<FishingMethod>((jsonStr) {
      return FishingMethod.fromJson(jsonStr);
    }).toList();
    List<String> fishNames = [];
    for (var i in fishList) {
      fishNames.add(i.name);
    }
    return fishNames;
  }

  List<String> _staticData = [];
  TextEditingController _descriptionController = TextEditingController();
  String description = "";

  void getNames() async {
    var _staticDataTmp = await fetchJSONData();
    setState(() {
      _staticData = _staticDataTmp;
    });
  }

  _onChangedDesc(String value) {
    setState(() {
      description = value;
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
                          hintText: "Dodatkowy opis",
                        ),
                        controller: _descriptionController,
                        onChanged: _onChangedDesc,
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
                              "Pomin",
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
          title: Text("Wybierz metode polowu"),
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
              Expanded(
                child: ListView(
                  children: _staticData.map((data) {
                    return ListTile(
                      onTap: () async {
                        await _askedToLead();
                        Navigator.of(context).pop(data + "\n" + description);
                      },
                      title: Text(data),
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        ));
  }
}
