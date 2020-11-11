import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'models/Fish.dart';
import 'views/diary/fishChooser.dart';
import 'package:image_picker/image_picker.dart';

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
  String _path;

  @override
  Widget build(BuildContext context) {
    void _showPhotoLibrary() async {
      ImagePicker imagePicker;
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
                      title: Text("Take a picture from camera")),
                  ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        _showPhotoLibrary();
                      },
                      leading: Icon(Icons.photo_library),
                      title: Text("Choose from photo library"))
                ]));
          });
    }

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
                FlatButton(
                  child: Text("Take Picture",
                      style: TextStyle(color: Colors.white)),
                  color: Colors.green,
                  onPressed: () {
                    _showOptions(context);
                  },
                ),
                _path == null ? SizedBox() : Image.file(File(_path)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
