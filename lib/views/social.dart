import 'package:flutter/material.dart';
import 'package:notatinik_wedkarza/common/design.dart';
import 'package:notatinik_wedkarza/models/user.dart';
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
  ApiSocial api = ApiSocial();
  var entries = [];

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
    var futureEntries = await api.getMessages(userInfo);
    entries = new List.from(futureEntries);
  }

  @override
  void initState() {
    getAllEntres();
    super.initState();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
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
                                    "daj znać znajomym jak idą Ci połowy,\noraz sprawdź co u nich!",
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
                              await api.postMessage(userInfo, content);
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
                                  onTap: () {
                                    print(entries[index].author);
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
