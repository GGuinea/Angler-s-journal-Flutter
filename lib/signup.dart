import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void validate() {
    formKey.currentState.validate();
  }

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
                          onPressed: validate,
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
