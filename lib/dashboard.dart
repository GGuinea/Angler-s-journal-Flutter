import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notatinik_wedkarza/atlas_screen.dart';
import 'package:notatinik_wedkarza/fishing_diary.dart';
import 'package:notatinik_wedkarza/models/user.dart';
import 'package:notatinik_wedkarza/views/drawer/drawer.dart';
import 'package:notatinik_wedkarza/views/social.dart';
import 'package:notatinik_wedkarza/views/to_do/to_do.dart';

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
    PostTable(),
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
    _children[1] = PostTable(userInfo: userInfo);
    _children[2] = Diary(userInfo: userInfo);
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
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ToDo(userInfo: userInfo),
                ));
              },
              icon: Icon(Icons.note_outlined),
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
            BottomNavigationBarItem(icon: Icon(Icons.tablet), label: "Tablica"),
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
