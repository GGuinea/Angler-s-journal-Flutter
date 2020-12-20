import 'package:flutter/material.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:notatinik_wedkarza/common/design.dart';
import 'package:notatinik_wedkarza/models/user.dart';
import 'package:notatinik_wedkarza/services/api_service.dart';
import 'package:notatinik_wedkarza/services/api_social.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class PostTable extends StatefulWidget {
  final User userInfo;
  PostTable({this.userInfo});
  @override
  _PostTableState createState() => _PostTableState(userInfo);
}

class _PostTableState extends State<PostTable> {
  final User userInfo;
  _PostTableState(this.userInfo);
  TextEditingController _contentController = TextEditingController();
  String content = "";
  ApiSocial apiSocial = ApiSocial();
  ApiService apiService = ApiService();
  var entries = [];
  bool remove = false;
  String titleForMarker = "";
  String description = "";
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  void _onControllerChange(String value) {
    setState(() {
      content = value;
    });
  }

  Future<bool> fetchData() => Future.delayed(Duration(seconds: 3), () {
        initState();
        return true;
      });

  void getAllEntres() async {
    var futureEntries = await apiSocial.getMessages(userInfo);
    entries = new List.from(futureEntries);
  }

  @override
  void initState() {
    getAllEntres();
    super.initState();
  }

  void _titleChanged(String value) {
    setState(() {
      titleForMarker = value;
    });
  }

  void _descriptionChanged(String value) {
    setState(() {
      description = value;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _onPostTapped(int mode, int id, String postContent) async {
    String title = "";
    if (mode == 0) {
      title = "Czy chces usunac?";
    } else if (mode == 1) {
      title = "Czy chces zgloscic?";
    } else {
      title = "Czy chces zaimportowac?";
    }
    await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(title),
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                    onPressed: () async {
                      if (mode == 0) {
                        await apiService.removePost(id, userInfo);
                        remove = true;
                      } else if (mode == 1) {
                        print("reporting is not working");
                      } else {
                        await showDialog(
                          context: context,
                          builder: (content) => SimpleDialog(
                            title: Text("Wpisz dane"),
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: SingleChildScrollView(
                                      child: Column(
                                    children: [
                                      TextField(
                                        decoration: InputDecoration(
                                          hintText: "Nazwa",
                                        ),
                                        controller: _titleController,
                                        onChanged: _titleChanged,
                                      ),
                                      TextField(
                                        decoration: InputDecoration(
                                          hintText: "Opis",
                                        ),
                                        controller: _descriptionController,
                                        onChanged: _descriptionChanged,
                                      ),
                                    ],
                                  )),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  FlatButton(
                                    onPressed: () async {
                                      var x = double.parse(postContent
                                          .split("\n")[1]
                                          .split(": ")[1]);
                                      var y = double.parse(postContent
                                          .split("\n")[2]
                                          .split(":")[1]);
                                      GeoCoord markerId = GeoCoord(x, y);
                                      Marker newMarker = Marker(
                                        markerId,
                                        info: titleForMarker,
                                        infoSnippet: description,
                                      );
                                      bool result = await apiService.addMarker(
                                          newMarker, userInfo);
                                      print(result);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Dodaj"),
                                  ),
                                  FlatButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Anuluj"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text("Tak"),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Nie"),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradiendColors,
          ),
        ),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(5),
                    top: Radius.circular(25),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          WaveWidget(
                            duration: 1,
                            config: CustomConfig(
                              gradients: [
                                [Colors.lightBlue, Colors.blue[200]],
                                [Colors.lightBlue, Colors.blue[400]],
                                [Colors.blue[300], Colors.blue[300]],
                                [Colors.blue, Colors.lightBlue],
                              ],
                              durations: [55000, 194400, 79800, 40000],
                              heightPercentages: [0.50, 0.53, 0.55, 0.52],
                              blur: MaskFilter.blur(BlurStyle.inner, 5),
                              gradientBegin: Alignment.centerLeft,
                              gradientEnd: Alignment.centerRight,
                            ),
                            waveAmplitude: 15.0,
                            backgroundColor: Colors.transparent,
                            size: Size(double.infinity, 150.0),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Miło Cię widzieć",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w200,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 70, left: 10, right: 10),
                            alignment: Alignment.center,
                            child: Text(
                              userInfo.userName + " !",
                              style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(5),
                        top: Radius.circular(5),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                bottom: 10, top: 10, left: 10, right: 10),
                            alignment: Alignment.center,
                            child: TextField(
                              maxLines: 2,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                focusColor: Colors.blue,
                                hintText:
                                    "Daj znać znajomym jak idą Ci połowy,\noraz sprawdź co u nich!",
                                hintStyle: TextStyle(
                                  color: Colors.black54,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              controller: _contentController,
                              onChanged: _onControllerChange,
                            ),
                          ),
                          RaisedButton(
                            shape: StadiumBorder(),
                            onPressed: () async {
                              await apiSocial.postMessage(
                                  userInfo, content, false);
                              setState(() {
                                _contentController.text = "";
                              });
                            },
                            color: Colors.orange[500],
                            splashColor: Colors.blue[200],
                            child: Text(
                              "Udostepnij",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FutureBuilder(
                        future: fetchData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: InkWell(
                                  onLongPress: () async {
                                    print(entries[index].isMarker);
                                    if (userInfo.userName ==
                                        entries[index].author) {
                                      print(entries[index].author);
                                      await _onPostTapped(
                                          0, entries[index].id, null);
                                    } else {
                                      if (entries[index].isMarker == false) {
                                        await _onPostTapped(
                                            1, entries[index].id, null);
                                      } else {
                                        await _onPostTapped(
                                            2,
                                            entries[index].id,
                                            entries[index].content);
                                      }
                                    }
                                    if (remove == true) {
                                      setState(
                                        () {
                                          entries.remove(entries[index]);
                                          remove = false;
                                        },
                                      );
                                    } else {
                                      setState(() {});
                                    }
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 2, bottom: 3, left: 5),
                                      child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              CircleAvatar(
                                                child: Text(
                                                  entries[index].author[0],
                                                ),
                                              ),
                                              Text(entries[index].author,
                                                  style: TextStyle()),
                                              Text(entries[index].time,
                                                  style: TextStyle()),
                                              Text(entries[index].date,
                                                  style: TextStyle()),
                                            ],
                                          ),
                                          Container(
                                            height: 80,
                                            child: VerticalDivider(
                                              color: Colors.black,
                                              thickness: 2,
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Text(entries[index].content,
                                                  style: TextStyle()),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: entries.length,
                          );
                        },
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
