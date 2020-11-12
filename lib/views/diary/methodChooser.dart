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

  void getNames() async {
    var _staticDataTmp = await fetchJSONData();
    setState(() {
      _staticData = _staticDataTmp;
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
                        Navigator.of(context).pop(data);
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
