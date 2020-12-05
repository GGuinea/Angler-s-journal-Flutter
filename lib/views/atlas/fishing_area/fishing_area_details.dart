import 'package:notatinik_wedkarza/models/fishing_area.dart';
import 'package:notatinik_wedkarza/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:notatinik_wedkarza/common/design.dart';
import 'package:notatinik_wedkarza/models/comment.dart';
import 'package:notatinik_wedkarza/models/user.dart';
import 'package:url_launcher/url_launcher.dart';

class FishingAreaDetails extends StatefulWidget {
  final User userInfo;
  final FishingArea fishingArea;
  FishingAreaDetails({this.userInfo, this.fishingArea});
  @override
  _FishingAreaDetailsState createState() =>
      _FishingAreaDetailsState(userInfo, fishingArea);
}

class _FishingAreaDetailsState extends State<FishingAreaDetails> {
  final User userInfo;
  FishingArea fishingArea;
  bool firstTime = true;
  final ApiService api = ApiService();

  _FishingAreaDetailsState(this.userInfo, this.fishingArea);
  TextEditingController _commentController = TextEditingController();
  String comment;
  _onChangedComment(String value) {
    setState(() {
      comment = value;
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _askForComment() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Nowy komentarz'),
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(2),
                  child: Column(
                    children: [
                      Text(
                        "*Dbaj o jakosc swojej wypowiedzi!",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(left: 8, right: 8),
                        padding: EdgeInsets.only(bottom: 4),
                        child: TextField(
                          maxLines: 6,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          controller: _commentController,
                          onChanged: _onChangedComment,
                        ),
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

  _laucchURL(String district, String name) async {
    String url = "http://www.google.com/search?q=" +
        name +
        "+" +
        district +
        "+" +
        "lowisko";
    await launch(url, forceWebView: true);
  }

  @override
  Widget build(BuildContext context) {
    List commentsCopy = new List.from(fishingArea.comments.reversed);
    return Scaffold(
      appBar: AppBar(
        title: Text(fishingArea.name),
        actions: [
          RaisedButton(
            onPressed: () async {
              await _laucchURL(fishingArea.district, fishingArea.name);
            },
            shape: StadiumBorder(),
            child: Text(
              "Szukaj w Google",
            ),
            color: Colors.orange[500],
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.bottomLeft,
            colors: gradiendColors,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            children: [
              Center(
                child: Text(
                  "OPIS",
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                fishingArea.description,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Montserrat-Medium',
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "KOMENTARZE",
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
              MaterialButton(
                shape: StadiumBorder(),
                color: Colors.orange[500],
                onPressed: () async {
                  await _askForComment();
                  if (comment != null && comment.length > 10) {
                    var date = new DateTime.now().toString();
                    var dateParse = DateTime.parse(date);
                    var formattedDate =
                        "${dateParse.day}-${dateParse.month}-${dateParse.year}";
                    Comment commentTmp = new Comment(
                      1,
                      comment,
                      userInfo.userName,
                      formattedDate,
                    );
                    Comment tmp = await api.addComment(
                        commentTmp, userInfo, fishingArea.name);
                    setState(() {
                      fishingArea.comments.add(tmp);
                    });
                  }
                },
                child: Text(
                  "Dodaj komentarz",
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: commentsCopy.length,
                    itemBuilder: (context, index) {
                      return new Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(10),
                            top: Radius.circular(12),
                          ),
                        ),
                        child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.orange[500],
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange,
                                  blurRadius: 240,
                                  spreadRadius: 5,
                                  offset: Offset(
                                    155,
                                    155,
                                  ),
                                ),
                              ],
                              gradient: LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.bottomLeft,
                                colors: gradiendColors,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(children: [
                                  Text("Autor: "),
                                  Text(
                                    commentsCopy[index].posterName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text("Data: "),
                                  //Text(fishingArea.comments[index].date,
                                  //  style: TextStyle(
                                  //    fontWeight: FontWeight.bold,
                                  //  ),
                                  //),
                                ]),
                                SizedBox(height: 2),
                                Row(children: [
                                  Text(
                                    commentsCopy[index].content,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  )
                                ]),
                              ],
                            )),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
