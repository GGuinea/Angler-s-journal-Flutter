import 'package:flutter/material.dart';
import 'package:notatinik_wedkarza/common/design.dart';
import 'package:notatinik_wedkarza/models/user.dart';
import 'package:notatinik_wedkarza/services/api_service.dart';

class BugReport extends StatefulWidget {
  final User userInfo;
  BugReport({this.userInfo});
  @override
  _BugReportState createState() => _BugReportState(userInfo);
}

class _BugReportState extends State<BugReport> {
  TextEditingController _bugController = TextEditingController();
  String bugContent;
  ApiService api = ApiService();
  final User userInfo;
  _BugReportState(this.userInfo);

  _onChangedBug(String value) {
    setState(() {
      bugContent = value;
    });
  }

  @override
  void dispose() {
    _bugController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Zaraportuj problem"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: gradiendColors,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 8, right: 8),
              padding: EdgeInsets.only(bottom: 4),
              child: TextField(
                maxLines: 6,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                controller: _bugController,
                onChanged: _onChangedBug,
              ),
            ),
            RaisedButton(
              color: Colors.orange[300],
              shape: StadiumBorder(),
              onPressed: () async {
                api.postBugInformation(bugContent, userInfo);
                Navigator.of(context).pop();
              },
              child: Text(
                "Wyslij informacje",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
