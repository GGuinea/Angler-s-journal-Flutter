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
  bool removed = false;
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
    await launch(url);
  }

  void _onCommentTapped(int mode, int id) async {
    String title = "";
    if (mode == 0) {
      title = "Czy chces usunac?";
    } else {
      title = "Czy chces zglosci?";
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
                        await api.removeComment(id, userInfo);
                      }
                      setState(() {
                        removed = true;
                      });
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
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: InkWell(
                        onLongPress: () async {
                          if (userInfo.userName ==
                              commentsCopy[index].posterName) {
                            _onCommentTapped(0, commentsCopy[index].id);
                            if (removed == true) {
                              setState(() {
                                fishingArea.comments
                                    .remove(commentsCopy[index]);
                                removed = false;
                              });
                            }
                          } else {
                            _onCommentTapped(0, commentsCopy[index].id);
                            print(commentsCopy[index].posterName);
                          }
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: 2, bottom: 3, left: 5),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    CircleAvatar(
                                      child: Text(
                                        commentsCopy[index].posterName[0],
                                      ),
                                    ),
                                    Text(commentsCopy[index].posterName,
                                        style: TextStyle()),
                                    Text(commentsCopy[index].date,
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
                                    Text(commentsCopy[index].content,
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
                  itemCount: commentsCopy.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
