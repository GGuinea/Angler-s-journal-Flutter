import 'package:flutter/material.dart';
import 'package:notatinik_wedkarza/models/user.dart';
import 'settings.dart';

class CustomDrawer extends StatefulWidget {
  final User userInfo;
  CustomDrawer({this.userInfo});
  @override
  _CustomDrawerState createState() => _CustomDrawerState(userInfo);
}

class _CustomDrawerState extends State<CustomDrawer> {
  final User userInfo;
  _CustomDrawerState(this.userInfo);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(userInfo.userName),
            accountEmail: Text("Undefined"),
            currentAccountPicture: CircleAvatar(
              child: Text(
                userInfo.userName[0],
              ),
              backgroundColor: Colors.white,
            ),
          ),
          ListTile(
            leading: Icon(Icons.arrow_forward),
            title: Text(
              "Statystyki",
            ),
          ),
          ListTile(
              leading: Icon(Icons.contacts),
              title: Text(
                "Znajomi",
              )),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              "Ustawienia",
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Settings(),
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
                  )))
        ],
      ),
    );
  }
}
