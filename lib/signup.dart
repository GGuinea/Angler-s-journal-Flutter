import 'package:notatinik_wedkarza/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart';
import 'package:notatinik_wedkarza/common/common_methods.dart';

import 'splash.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ApiService api = ApiService();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Form(
                key: formKey,
                child: Stack(
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.fromLTRB(15, 50, 0, 0),
                        child: Text(
                          "NOWE",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Container(
                        padding: EdgeInsets.fromLTRB(15, 80, 0, 0),
                        child: Text(
                          "KONTO",
                          style: TextStyle(
                            fontSize: 55,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Container(
                      padding: EdgeInsets.only(top: 150, left: 20, right: 20),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                          labelText: "EMAIL",
                        ),
                        validator: MultiValidator([
                          RequiredValidator(errorText: "Wymagane"),
                          EmailValidator(errorText: "Nie poprawny mail"),
                        ]),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 220, left: 20, right: 20),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                          labelText: "HASLO",
                        ),
                        validator: MultiValidator([
                          RequiredValidator(errorText: "Wymagane"),
                          MinLengthValidator(6, errorText: "Min 5 znakow"),
                          MaxLengthValidator(20, errorText: "Max 20 znakow"),
                        ]),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 290, left: 20, right: 20),
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                          labelText: "NAZWA UZYTKOWNIKA",
                        ),
                        validator: MultiValidator([
                          RequiredValidator(errorText: "Wymagane"),
                          MinLengthValidator(6, errorText: "Min 5 znakow"),
                          MaxLengthValidator(20, errorText: "Max 20 znakow"),
                        ]),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 390, left: 20, right: 20),
                      child: Center(
                        child: MaterialButton(
                          onPressed: () async {
                            if (isValid(formKey)) {
                              var result = api.createUser(
                                  _usernameController.text,
                                  _emailController.text,
                                  _passwordController.text);
                              Response serverResponse = await result;
                              printOutput(serverResponse.body, context);
                              if (serverResponse.statusCode == 200) {
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) => SplashScreen(),
                                ));
                              }
                            }
                          },
                          elevation: 10,
                          minWidth: double.infinity,
                          color: Colors.blue,
                          splashColor: Colors.lightBlueAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "Stworz konto",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 440, left: 20, right: 20),
                      child: Center(
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          elevation: 10,
                          minWidth: double.infinity,
                          color: Colors.blue,
                          splashColor: Colors.lightBlueAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "Powrot",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
