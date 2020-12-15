import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notatinik_wedkarza/models/user.dart';
import 'package:notatinik_wedkarza/services/api_social.dart';
import 'package:notatinik_wedkarza/views/drawer/bug_report.dart';
import 'package:notatinik_wedkarza/views/drawer/change_password.dart';

class CustomDrawer extends StatefulWidget {
  final User userInfo;
  CustomDrawer({this.userInfo});
  @override
  _CustomDrawerState createState() => _CustomDrawerState(userInfo);
}

class _CustomDrawerState extends State<CustomDrawer> {
  final User userInfo;
  _CustomDrawerState(this.userInfo);
  final List<Widget> _child = [];
  int drawerIndicator = 0;
  TextEditingController _friendUserName = TextEditingController();
  String friendUsername;
  bool flag = false;
  void populateList() async {
    _child.add(returnDrawer());
  }

  void _friendNameController(String value) {
    setState(() {
      friendUsername = value;
    });
  }

  @override
  void dispose() {
    _friendUserName.dispose();
    super.dispose();
  }

  @override
  void initState() {
    populateList();
    getAllEntres();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: _child[drawerIndicator],
    );
  }

  Widget returnDrawer() {
    return Column(
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text(userInfo.userName),
          accountEmail: Text(userInfo.email),
          currentAccountPicture: CircleAvatar(
            child: Text(
              userInfo.userName[0],
            ),
            backgroundColor: Colors.white,
          ),
        ),
        ListTile(
          leading: Icon(Icons.format_list_numbered),
          title: Text(
            "Statystyki",
          ),
        ),
        ListTile(
            leading: Icon(Icons.contacts),
            title: Text(
              "Znajomi",
            ),
            onTap: () async {
              Widget tmp = await returnFriends();
              setState(() {
                _child.add(tmp);
                drawerIndicator = 1;
              });
            }),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text(
            "Zmien haslo",
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChangePassword(userInfo: userInfo),
              ),
            );
          },
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ListTile(
              leading: Icon(Icons.bug_report),
              title: Text(
                "Raport problemu",
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BugReport(userInfo: userInfo),
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }

  Future<bool> fetchData() => Future.delayed(Duration(seconds: 3), () {
        initState();
        //getAllEntres();
        return true;
      });

  final ApiSocial api = ApiSocial();
  var entries = [];

  void getAllEntres() async {
    var futureEntries = await api.getFriendList(userInfo);
    entries = new List.from(futureEntries.reversed);
  }

  Future<Widget> returnFriends() async {
    return Column(
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text(userInfo.userName),
          accountEmail: Text(userInfo.email),
          currentAccountPicture: CircleAvatar(
            child: Text(
              userInfo.userName[0],
            ),
            backgroundColor: Colors.white,
          ),
        ),
        ListTile(
          leading: Icon(Icons.add),
          title: Text(
            "Dodaj znajomego",
          ),
          onTap: () async {
            await getDialog();
            setState(() {
              drawerIndicator = 0;
            });
          },
        ),
        ListTile(
          leading: Icon(Icons.arrow_left),
          title: Text(
            "Powrot",
          ),
          onTap: () {
            setState(() {
              drawerIndicator = 0;
            });
          },
        ),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: InkWell(
                  onTap: () {
                    final action = CupertinoActionSheet(
                        title: Text(entries[index], style: TextStyle()),
                        message: Text("Wybierz opcje"),
                        actions: [
                          CupertinoActionSheetAction(
                              child: Text("Usun"),
                              isDefaultAction: true,
                              onPressed: () {
                                api.removeFriend(userInfo, entries[index]);
                                setState(() {
                                  entries.remove(index);
                                });
                                Navigator.of(context).pop();
                              })
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          child: Text("Powrot"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ));
                    showCupertinoModalPopup(
                        context: context, builder: (context) => action);
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          child: Text(
                            entries[index][0],
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(entries[index], style: TextStyle()),
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: entries.length,
          ),
        ),
      ],
    );
  }

  getDialog() async {
    await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "nazwa znajomego",
                      ),
                      controller: _friendUserName,
                      onChanged: _friendNameController,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FlatButton(
                          onPressed: () async {
                            int statusCode =
                                await api.addFriend(userInfo, friendUsername);
                            setState(() {
                              if (statusCode == 200) {
                                setState(() {
                                  entries.add(friendUsername);
                                  drawerIndicator = 0;
                                });
                              }
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text("Dodaj"),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Anuluj"),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
