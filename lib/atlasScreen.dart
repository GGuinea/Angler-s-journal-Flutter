import 'package:flutter/material.dart';

class AtlasScreen extends StatefulWidget {
  @override
  _AtlasScreenState createState() => _AtlasScreenState();
}

Widget cards() {
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    clipBehavior: Clip.antiAlias,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset('assets/images/fish.png'),
      ],
    ),
  );
}

class _AtlasScreenState extends State<AtlasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(top: 10),
            ),
            cards(),
          ],
        ),
      ),
    );
  }
}
