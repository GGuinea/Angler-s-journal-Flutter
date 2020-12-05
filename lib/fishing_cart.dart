import 'package:NotatnikWedkarza/models/fishing_entry.dart';
import 'package:flutter/material.dart';

class FishingCard extends StatelessWidget {
  const FishingCard({
    Key key,
    @required this.fishingEntry,
  }) : super(key: key);

  final FishingEntry fishingEntry;

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.symmetric(vertical: 10),
      //margin: EdgeInsets.only(bottom: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.amberAccent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.green,
              offset: Offset(2, 3),
              blurRadius: 10,
            )
          ]),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Image.asset(fishingEntry.img),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  fishingEntry.name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  fishingEntry.dateTime,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
