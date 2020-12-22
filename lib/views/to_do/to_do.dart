import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notatinik_wedkarza/common/design.dart';
import 'package:notatinik_wedkarza/models/to_do.dart';
import 'package:notatinik_wedkarza/models/user.dart';
import 'package:notatinik_wedkarza/services/api_service.dart';

class ToDo extends StatefulWidget {
  final User userInfo;
  ToDo({this.userInfo});
  @override
  _ToDoState createState() => _ToDoState(userInfo);
}

class _ToDoState extends State<ToDo> {
  final User userInfo;
  _ToDoState(this.userInfo);
  TextEditingController _todoController = TextEditingController();
  bool remove = false;
  String todoContent = "";
  var entries = [];
  ApiService api = ApiService();

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  onTodoChange(String value) {
    setState(() {
      todoContent = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Organizer"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomCenter,
            colors: gradiendColors,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: InkWell(
                onTap: () {},
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(25),
                      top: Radius.circular(25),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 12, bottom: 12, left: 16, right: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Nowe zadanie",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "wpisz co masz do zrobienia",
                                ),
                                controller: _todoController,
                                onChanged: onTodoChange,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RaisedButton(
                                onPressed: () async {
                                  if (todoContent.length != 0) {
                                    final todo = await api.addToDo(
                                        userInfo, _todoController.text);
                                    var jsonDecoded = json
                                        .decode(utf8.decode(todo.bodyBytes));
                                    setState(() {
                                      entries
                                          .add(ToDoModel.fromJson(jsonDecoded));
                                      _todoController.clear();
                                    });
                                  }
                                },
                                color: Colors.blue,
                                child: Text("Dodaj")),
                          ],
                        ),
                        FutureBuilder(
                          future: fetchData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ReorderableListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: InkWell(
                                    onTap: () async {
                                      await _onPostTapped(entries[index].id);
                                      if (remove == true) {
                                        setState(
                                          () {
                                            entries.remove(entries[index]);
                                            remove = false;
                                          },
                                        );
                                      } else {
                                        setState(() {});
                                      }
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 12, bottom: 12, left: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(entries[index].content,
                                                    style: TextStyle(
                                                        fontSize: 20)),
                                              ],
                                            ),
                                            Icon(Icons.delete),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: entries.length,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onPostTapped(int id) async {
    String title = "Czy zadanie zostało wykonane?";
    await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(title),
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                    onPressed: () async {
                      api.removeTodo(id, userInfo);
                      Navigator.of(context).pop();
                      setState(() {
                        remove = true;
                      });
                    },
                    child: Text("Tak"),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Nie"),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool> fetchData() => Future.delayed(
        Duration(seconds: 2),
        () {
          initState();
          return true;
        },
      );

  @override
  void initState() {
    getAllEntres();
    super.initState();
  }

  void getAllEntres() async {
    var futureEntries = await api.getToDos(userInfo);
    entries = new List.from(futureEntries);
  }
}
