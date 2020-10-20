import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'placeholder_widget.dart';
import 'drawer.dart';
import 'fishingDiary.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 1;
  final List<Widget> _children = [
    PlaceholderWidget(Colors.white),
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
    return WillPopScope(
      onWillPop: () => popped(),
      child: Scaffold(
        endDrawer: CustomDrawer(),
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
