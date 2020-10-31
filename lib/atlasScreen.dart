import 'package:flutter/material.dart';
import 'fishList.dart';

class AtlasScreen extends StatefulWidget {
  @override
  _AtlasScreenState createState() => _AtlasScreenState();
}

final List<Widget> listOfElements = [
  FishList()
];

Widget cards(String name, int index, context) {
  return Card(
    child: InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => listOfElements[index]));
      },
      child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.lightBlue.shade50, Colors.blueAccent]),
            border: Border.all(
              color: Colors.grey,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.only(top: 40, bottom: 40),
          child: Center(
              child: Text("$name",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 30,
                  )))),
    ),
    elevation: 20,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    clipBehavior: Clip.antiAlias,
  );
}

class _AtlasScreenState extends State<AtlasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              cards("Atlas ryb", 0, context),
              cards("List lowisk", 1, context),
              cards("Regulaminy", 2, context),
            ],
          ),
        ),
      ),
    );
  }
}
