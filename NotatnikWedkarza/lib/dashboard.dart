import 'package:flutter/material.dart';
import 'appBars.dart';
import 'placeholder_widget.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    PlaceholderWidget(Colors.white),
    PlaceholderWidget(Colors.deepOrange),
    PlaceholderWidget(Colors.green),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar,
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.art_track_outlined),
            label: "Atlas",
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.home_outlined),
            label: "Strona glowna",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.anchor_outlined), label: "Polowy")
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
