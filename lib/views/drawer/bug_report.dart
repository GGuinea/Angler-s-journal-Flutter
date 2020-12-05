import 'package:flutter/material.dart';

class BugReport extends StatefulWidget {
  @override
  _BugReportState createState() => _BugReportState();
}

class _BugReportState extends State<BugReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Zaraportuj problem"),
      ),
    );
  }
}
