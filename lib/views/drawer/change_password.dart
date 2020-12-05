import 'package:flutter/material.dart';
import 'package:notatinik_wedkarza/common/design.dart';
import 'package:notatinik_wedkarza/models/user.dart';
import 'package:notatinik_wedkarza/services/api_service.dart';

class ChangePassword extends StatefulWidget {
  final User userInfo;
  ChangePassword({this.userInfo});
  @override
  _ChangePasswordState createState() => _ChangePasswordState(userInfo);
}

class _ChangePasswordState extends State<ChangePassword> {
  final User userInfo;
  _ChangePasswordState(this.userInfo);
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _newRepeatedPasswordController =
      TextEditingController();
  String oldPassword;
  String newPassword;
  String repeatedNewPassword;
  ApiService api = ApiService();

  _onChagneOldPassword(String value) {
    setState(() {
      oldPassword = value;
    });
  }

  _onChagneNewPassword(String value) {
    setState(() {
      newPassword = value;
    });
  }

  _onChagneRepeatedNewPassword(String value) {
    setState(() {
      repeatedNewPassword = value;
    });
  }

  Future<void> passwordAlert() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Problem!'),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                        "Nie udalo sie zmienic hasla\n, sprawdz czy wprowadzone hasla sa poprawne"),
                  ],
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Zmien haslo"),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topCenter,
            colors: gradiendColors,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Wprowadz stare haslo',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  controller: _oldPasswordController,
                  onChanged: _onChagneOldPassword,
                ),
                SizedBox(height: 5),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Wprowadz nowe haslo',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  controller: _newPasswordController,
                  onChanged: _onChagneNewPassword,
                ),
                SizedBox(height: 5),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Wprowadz ponownie nowe haslo',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  controller: _newRepeatedPasswordController,
                  onChanged: _onChagneRepeatedNewPassword,
                ),
                SizedBox(height: 20),
                RaisedButton(
                  shape: StadiumBorder(),
                  color: Colors.orange[300],
                  onPressed: () async {
                    if (oldPassword == userInfo.password &&
                        newPassword == repeatedNewPassword) {
                      await api.chagnePassword(newPassword, userInfo);
                    } else {
                      await passwordAlert();
                    }
                  },
                  child: Text("Zmien haslo"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
