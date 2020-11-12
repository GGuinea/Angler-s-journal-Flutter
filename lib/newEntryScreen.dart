import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'models/Fish.dart';
import 'views/diary/fishChooser.dart';
import 'package:image_picker/image_picker.dart';

import 'views/diary/methodChooser.dart';
import 'views/takePicturePage.dart';

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
  List<String> methods = [];
  String _path;

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
      ),
      body: Container(
        height: double.infinity,
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
                      fishes.add(output.name + output.size + output.weight);
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
