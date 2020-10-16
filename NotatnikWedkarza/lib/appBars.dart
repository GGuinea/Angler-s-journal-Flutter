import 'package:flutter/material.dart';

AppBar topBar = AppBar(
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
    IconButton(
      onPressed: () {
        print("go to settings");
      },
      icon: Icon(Icons.account_circle_outlined),
    ),
  ],
);

