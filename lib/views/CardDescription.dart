import 'package:flutter/material.dart';

class CardDescription extends StatefulWidget {
  final String name;
  final String desc;
  final String img;
  CardDescription({this.name, this.desc, this.img});
  @override
  _CardDescriptionState createState() => _CardDescriptionState(name, desc, img);
}

class _CardDescriptionState extends State<CardDescription> {
  String name;
  String desc;
  String img;

  _CardDescriptionState(this.name, this.desc, this.img);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("$name"),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.grey,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Image.asset('assets/' + img),
                    Padding(
                      padding: EdgeInsets.only(top: 50, left: 20),
                      child: Text(
                        '$desc',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ));
  }
}
