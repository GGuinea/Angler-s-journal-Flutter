import 'package:NotatnikWedkarza/common/design.dart';
import 'package:flutter/material.dart';

class PasswordReminderView extends StatelessWidget {
  final _usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Przypomnij haslo",
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradiendColors,
          ),
        ),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                      "*Podaj nam swoja nazwe uzytkownika, a my wyslemy na Twoj email haslo tymczasowe"),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                      labelText: "Nazwa uzytkownika",
                    ),
                  ),
                ],
              ),
            ),
            RaisedButton(
              shape: StadiumBorder(),
              child: Text(
                "Wyslij",
              ),
              color: Colors.orange[400],
              splashColor: Colors.blue,
              onPressed: () {
                if (_usernameController.text == null ||
                    _usernameController.text == "") {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: [
                              Text("Wprowadz poprawne dane"),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: Text('Ok'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ]),
                  );
                } else {
                  print("Ok");
                }
              },
            )
          ],
        )),
      ),
    );
  }
}
