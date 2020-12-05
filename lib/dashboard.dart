import 'package:NotatnikWedkarza/atlas_screen.dart';
import 'package:NotatnikWedkarza/fishing_diary.dart';
import 'package:NotatnikWedkarza/models/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'drawer.dart';

class Dashboard extends StatefulWidget {
  final User userInfo;
  Dashboard({this.userInfo});
  @override
  _DashboardState createState() => _DashboardState(userInfo);
}

class _DashboardState extends State<Dashboard> {
  final User userInfo;
  _DashboardState(this.userInfo);
  int _currentIndex = 1;
  final List<Widget> _children = [
    AtlasScreen(),
    Diary(),
  ];

  DateTime currentTime;
  Future<bool> popped() {
    print("pooped");
    DateTime now = DateTime.now();
    if (currentTime == null ||
        now.difference(currentTime) > Duration(seconds: 2)) {
      currentTime = now;
      Fluttertoast.showToast(
        msg: "Nacisnij jeszcze raz aby wyjsc",
        toastLength: Toast.LENGTH_SHORT,
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    _children[0] = AtlasScreen(userInfo: userInfo);
    _children[1] = Diary(userInfo: userInfo);
    return WillPopScope(
      onWillPop: () => popped(),
      child: Scaffold(
        endDrawer: CustomDrawer(userInfo: userInfo),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueAccent,
          title: Image.asset(
            'assets/images/fish.png',
            fit: BoxFit.cover,
            width: 100,
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                print("go to page with timer");
              },
              icon: Icon(Icons.note_outlined),
            ),
            IconButton(
              onPressed: () {
                print("go to page with timer");
              },
              icon: Icon(Icons.access_alarms),
            ),
            IconButton(
              onPressed: () {
                print("turn on flashlight");
              },
              icon: Icon(Icons.highlight),
            ),
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.account_circle_outlined),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
            ),
          ],
        ),
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.art_track_outlined),
              label: "Atlas",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.anchor_outlined), label: "Polowy"),
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
