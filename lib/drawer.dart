import 'package:flutter/material.dart';
import 'settings.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Luminesco"),
            accountEmail: Text("Luminesco@gmail.com"),
            currentAccountPicture: CircleAvatar(
              child: Text(
                "L",
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
