import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'appBars.dart';
import 'placeholder_widget.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 1;
  final List<Widget> _children = [
    PlaceholderWidget(Colors.white),
    PlaceholderWidget(Colors.deepOrange),
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
        appBar: topBar,
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
