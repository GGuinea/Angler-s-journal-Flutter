import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notatinik_wedkarza/models/fish.dart';
import 'package:notatinik_wedkarza/models/fishing_entry.dart';
import 'package:notatinik_wedkarza/models/user.dart';
import 'package:notatinik_wedkarza/views/diary/fish_chooser.dart';
import 'package:notatinik_wedkarza/views/diary/method_chooser.dart';
import 'package:notatinik_wedkarza/views/take_picture_page.dart';

import 'common/design.dart';
import 'services/api_service.dart';

class NewEntryScreen extends StatefulWidget {
  final User userInfo;
  NewEntryScreen({this.userInfo});
  @override
  _NewEntryScreenState createState() => _NewEntryScreenState(userInfo);
}

class _NewEntryScreenState extends State<NewEntryScreen> {
  final User userInfo;
  _NewEntryScreenState(this.userInfo);
  String title = "";
  String waterName = "";
  String description = "";
  String dateStart = "";
  String length = "";
  String hook = "";
  String line = "";
  List<String> fishes = [];
  List<String> methods = [];
  List<String> additionals = [];
  String _path;
  TextEditingController _lineController = TextEditingController();
  TextEditingController _hookController = TextEditingController();
  TextEditingController _lengthController = TextEditingController();
  final dateControllerStart = TextEditingController();
  ApiService api = ApiService();

  _onChangedLine(String value) {
    setState(() {
      line = value;
    });
  }

  _onChangedLength(String value) {
    setState(() {
      length = value;
    });
  }

  _onChangedHook(String value) {
    setState(() {
      hook = value;
    });
  }

  @override
  void dispose() {
    _lineController.dispose();
    _hookController.dispose();
    _lengthController.dispose();
    dateControllerStart.dispose();
    super.dispose();
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
                          hintText: "Zylka [mm]",
                        ),
                        controller: _lineController,
                        onChanged: _onChangedLine,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Hak [mm]",
                        ),
                        controller: _hookController,
                        onChanged: _onChangedHook,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Odleglosc [mm]",
                        ),
                        controller: _lengthController,
                        onChanged: _onChangedLength,
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
    void _showPhotoLibrary() async {
      ImagePicker imagePicker = new ImagePicker();
      final file = await imagePicker.getImage(source: ImageSource.gallery);

      setState(() {
        _path = file.path;
      });
    }

    void _showCamera() async {
      final cameras = await availableCameras();
      final camera = cameras.first;

      String result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TakePicturePage(camera: camera)));

      setState(() {
        _path = result;
      });
    }

    void _showOptions(BuildContext context) async {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
                height: 150,
                child: Column(children: <Widget>[
                  ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        _showCamera();
                      },
                      leading: Icon(Icons.photo_camera),
                      title: Text("Zrob nowe zdjecie")),
                  ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        _showPhotoLibrary();
                      },
                      leading: Icon(Icons.photo_library),
                      title: Text("Wybierz zdjecie z galerii"))
                ]));
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Dodaj wyprawe"),
        actions: [
          RaisedButton(
            onPressed: () async {
              final bytes = await File(_path).readAsBytes();
              String imgConverted = base64Encode(bytes);
              String fishesConverted = "";
              String methodsConverted = "";
              String additionalsConverted = "";
              for (String str in fishes) {
                fishesConverted += str;
                fishesConverted += "\n";
              }
              for (String str in methods) {
                methodsConverted += str;
                methodsConverted += "\n";
              }
              for (String str in additionals) {
                additionalsConverted += str;
                additionalsConverted += "\n";
              }
              FishingEntry fishingEntry = new FishingEntry(
                  1,
                  title,
                  imgConverted,
                  description,
                  waterName,
                  dateStart,
                  methodsConverted,
                  fishesConverted,
                  additionalsConverted);
              api.addEntry(fishingEntry, userInfo);
              Navigator.of(context).pop();
            },
            color: Colors.orange[400],
            splashColor: Colors.blue,
            shape: StadiumBorder(),
            child: Text("Zapisz"),
          )
        ],
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradiendColors,
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
                TextField(
                    decoration: InputDecoration(
                      labelText: 'Dodatkowe informacje',
                    ),
                    onChanged: (val) {
                      description = val;
                    }),
                TextField(
                    onTap: () async {
                      var date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      dateControllerStart.text =
                          date.toString().substring(0, 10);
                      dateStart = dateControllerStart.text;
                    },
                    readOnly: true,
                    controller: dateControllerStart,
                    decoration: InputDecoration(
                      labelText: 'Data wyprawy',
                    ),
                    onChanged: (val) {
                      dateStart = val;
                    }),
                SizedBox(height: 20),
                RaisedButton(
                  shape: StadiumBorder(),
                  color: Colors.orange[300],
                  onPressed: () async {
                    final result =
                        Navigator.of(context).push(MaterialPageRoute<String>(
                      builder: (context) => MethodChooser(),
                    ));
                    String output = await result;
                    setState(() {
                      if (output != null) methods.add(output);
                    });
                  },
                  child: Text("Wybierz metode polowu"),
                ),
                methods != null && methods.length != 0
                    ? Column(
                        children: methods.map((data) {
                          return ListTile(
                            title: Text(data),
                            trailing: IconButton(
                              icon: Icon(Icons.remove),
                              color: Colors.red,
                              onPressed: () {
                                setState(() {
                                  methods.remove(data);
                                });
                              },
                            ),
                          );
                        }).toList(),
                      )
                    : SizedBox(),
                RaisedButton(
                  shape: StadiumBorder(),
                  color: Colors.orange[300],
                  onPressed: () async {
                    final result =
                        Navigator.of(context).push(MaterialPageRoute<Fish>(
                      builder: (context) => FishChooser(),
                    ));
                    Fish output = await result;
                    setState(() {
                      fishes.add(output.name +
                          " " +
                          output.size +
                          " " +
                          output.weight);
                    });
                  },
                  child: Text("Dodaj zlowiona rybe"),
                ),
                fishes != null && fishes.length != 0
                    ? Column(
                        children: fishes.map((data) {
                          return ListTile(
                            title: Text(data),
                            trailing: IconButton(
                              icon: Icon(Icons.remove),
                              color: Colors.red,
                              onPressed: () {
                                setState(() {
                                  fishes.remove(data);
                                });
                              },
                            ),
                          );
                        }).toList(),
                      )
                    : SizedBox(),
                RaisedButton(
                  shape: StadiumBorder(),
                  color: Colors.orange[300],
                  onPressed: () async {
                    await _askedToLead();
                    setState(() {
                      additionals.add("Zylka:" +
                          line +
                          "\nHak:" +
                          hook +
                          "\nOdleglosc:" +
                          length);
                    });
                  },
                  child: Text("Dodaj szczegol"),
                ),
                additionals != null && additionals.length != 0
                    ? Column(
                        children: additionals.map((data) {
                          return ListTile(
                            title: Text(data),
                            trailing: IconButton(
                              icon: Icon(Icons.remove),
                              color: Colors.red,
                              onPressed: () {
                                setState(() {
                                  additionals.remove(data);
                                });
                              },
                            ),
                          );
                        }).toList(),
                      )
                    : SizedBox(),
                RaisedButton(
                  shape: StadiumBorder(),
                  child: Text("Dodaj zdjecie"),
                  color: Colors.orange[300],
                  onPressed: () {
                    _showOptions(context);
                  },
                ),
                _path == null
                    ? SizedBox()
                    : Container(
                        height: 300,
                        width: 400,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.file(File(_path)),
                              IconButton(
                                icon: Icon(Icons.remove),
                                color: Colors.red,
                                onPressed: () {
                                  setState(() {
                                    _path = null;
                                  });
                                },
                              )
                            ]),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
