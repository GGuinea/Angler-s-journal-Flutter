import 'package:flutter/material.dart';
import 'models/FishingEntry.dart';
import 'FishingCart.dart';
import 'models/User.dart';
import 'services/api_service.dart';

class Diary extends StatefulWidget {
  final User userInfo;
  Diary({this.userInfo});
  @override
  _DiaryState createState() => _DiaryState(userInfo);
}

class _DiaryState extends State<Diary> {
  final User userInfo;
  _DiaryState(this.userInfo);
  final dateControllerStart = TextEditingController();
  final dateControllerEnd = TextEditingController();
  String title = "";
  String waterName = "";
  String description = "";
  String dateStart = "";
  String dateEnd = "s";
  List<FishingEntry> fishingEntries = [
    FishingEntry("Polowy", "assets/images/fish.png", "Nawet spoko",
        "Zalew slok", "data"),
    FishingEntry("Wypad z ziomkiem", "assets/images/fish.png", "Nawet spoko",
        "Zalew wawrzkowizna", "data1"),
    FishingEntry(
        "Polowy samemu", "assets/images/fish.png", "slabo", "ZPT", "data3"),
  ];
  final ApiService api = ApiService();

  @override
  void dispose() {
    dateControllerStart.dispose();
    dateControllerEnd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    api.getEntries(userInfo);
    return Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: 39, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: fishingEntries.length,
                  itemBuilder: (context, index) => ListTile(
                    title: FishingCard(fishingEntry: fishingEntries[index]),
                    onTap: () {},
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.grey,
            splashColor: Colors.blue,
            onPressed: showAlertDialog,
            child: Icon(
              Icons.add,
              color: Colors.blue,
              size: 30,
            )));
  }

  void showAlertDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              content: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width - 20,
                  child: Column(
                    children: [
                      Center(
                        child: Text("Wprowadz informacje"),
                      ),
                      TextField(
                          decoration: InputDecoration(
                            labelText: 'Tytul wyprawy',
                          ),
                          onChanged: (val) {
                            title = val;
                          }),
                      TextField(
                          decoration: InputDecoration(
                            labelText: 'Nazwa zbiornika',
                          ),
                          onChanged: (val) {
                            waterName = val;
                          }),
                      TextField(
                          decoration: InputDecoration(
                            labelText: 'Dodatkowe informacje',
                          ),
                          onChanged: (val) {
                            print(val);
                            description = val;
                          }),
                      TextField(
                          readOnly: true,
                          controller: dateControllerStart,
                          decoration: InputDecoration(
                            hintText: "Poczatek",
                          ),
                          onTap: () async {
                            var date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            dateControllerStart.text =
                                date.toString().substring(0, 10);
                            dateStart = dateControllerStart.text;
                          }),
                      TextField(
                          readOnly: true,
                          controller: dateControllerEnd,
                          decoration: InputDecoration(
                            hintText: "Koniec",
                          ),
                          onTap: () async {
                            var date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            dateControllerEnd.text =
                                date.toString().substring(0, 10);
                            dateEnd = dateControllerEnd.text;
                          }),
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RaisedButton(
                            onPressed: addFishEntry,
                            color: Colors.blueAccent,
                            child: Text(
                              "Dodaj",
                            ),
                          ),
                          RaisedButton(
                            onPressed: () => Navigator.pop(context, false),
                            color: Colors.blueAccent,
                            child: Text(
                              "Anuluj",
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  void addFishEntry() {
    Navigator.pop(context);
    setState(() {
      fishingEntries.add(FishingEntry(
          title, 'assets/images/fish.png', description, waterName, dateStart));
    });
  }
}
