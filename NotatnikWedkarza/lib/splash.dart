import 'package:flutter/material.dart';
import 'signup.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.fromLTRB(15, 50, 0, 0),
                      child: Text(
                        "NOTATNIK",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  Container(
                      padding: EdgeInsets.fromLTRB(15, 80, 0, 0),
                      child: Text(
                        "WEDKARZA",
                        style: TextStyle(
                          fontSize: 55,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 130, 21, 0),
                    child: Center(
                        child: Image(
                      image: AssetImage("assets/images/blueLine.png"),
                    )),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 230, left: 20, right: 20),
                    child: TextFormField(
                        decoration: InputDecoration(
                      labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                      labelText: "EMAIL",
                    )),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 290, left: 20, right: 20),
                    child: TextFormField(
                        decoration: InputDecoration(
                      labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                      labelText: "HASLO",
                    )),
                  ),
                  SizedBox(height: 5),
                  Container(
                    alignment: Alignment(1.0, 0),
                    padding: EdgeInsets.only(top: 340),
                    child: MaterialButton(
                      onPressed: () {},
                      child: Text("Przypomnij haslo",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          )),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 390, left: 20, right: 20),
                    child: Center(
                      child: MaterialButton(
                        onPressed: () {},
                        elevation: 10,
                        minWidth: double.infinity,
                        color: Colors.blue,
                        splashColor: Colors.lightBlueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.only(top: 440, left: 20, right: 20),
                    child: Center(
                      child: MaterialButton(
                          onPressed: () {},
                          splashColor: Colors.blue,
                          minWidth: double.infinity,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.black),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: ImageIcon(
                                    AssetImage('assets/images/google.png')),
                              ),
                              Center(
                                child: Text(
                                  "Login with Google",
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          )),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.only(top: 500, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Nowy uzytkownik?",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        SizedBox(width: 3),
                        MaterialButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SignupPage(),
                            ));
                          },
                          child: Text("Zaloz konto",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                fontFamily: 'Montserrat',
                                decoration: TextDecoration.underline,
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
