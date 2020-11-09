import 'package:flutter/material.dart';
import 'models/FishingEntry.dart';
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
  final ApiService api = ApiService();
  List<FishingEntry> entries = [];

  @override
  void dispose() {
    dateControllerStart.dispose();
    dateControllerEnd.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getAllEntres();
    super.initState();
  }

  void getAllEntres() async {
    var futureEntries = await api.getEntries(userInfo);
    entries = futureEntries;
  }

  Future<bool> fetchData() => Future.delayed(Duration(seconds: 1), () {
        debugPrint('Step 2, fetch data');
        initState();
        return true;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: FutureBuilder(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: InkWell(
                        onTap: () {},
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 22, bottom: 22, left: 16, right: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      child: Text(
                                        entries[index].name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  height: 150,
                                  width: 150,
                                )
                              ],
                            ),
                          ),
                        ),
                      ));
                },
                itemCount: entries.length,
              );
            }),
      ),
    );
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
    //pushing server
  }
}
