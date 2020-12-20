import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notatinik_wedkarza/common/common_methods.dart';
import 'package:notatinik_wedkarza/models/user.dart';
import 'remind_password.dart';
import 'signup.dart';
import 'dashboard.dart';
import 'package:http/http.dart';
import 'services/api_service.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ApiService api = ApiService();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _usernameCotroller = TextEditingController();
  final _passwordController = TextEditingController();
  final String passwordForGoogleAccounts = "qwer#@22#(9FFs)";
  User user = new User();
  GoogleSignIn googleSignIn = GoogleSignIn(
      clientId:
          "434767421435-v7880rd311cfjdi1l11phcvrsesmeeca.apps.googleusercontent.com");
  GoogleSignInAccount googleAccout;
  GoogleSignInAuthentication auth;

  @override
  void initState() {
    checkPrefs();
    super.initState();
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
                        controller: _usernameCotroller,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                          labelText: "NAZWA UZYTKOWNIKA",
                        ),
                        validator: MultiValidator([
                          RequiredValidator(errorText: "Wymagane"),
                          //EmailValidator(errorText: "Nie poprawny mail")
                        ]),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 290, left: 20, right: 20),
                      child: TextFormField(
                        obscureText: true,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                          labelText: "HASLO",
                        ),
                        validator: MultiValidator([
                          RequiredValidator(errorText: "Wymagane"),
                        ]),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      alignment: Alignment(1.0, 0),
                      padding: EdgeInsets.only(top: 340),
                      child: MaterialButton(
                        onPressed: () async {
                          Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) => PasswordReminderView(),
                          ));
                        },
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
                          onPressed: () async {
                            if (isValid(formKey)) {
                              var restult = api.loginUser(
                                  _usernameCotroller.text,
                                  _passwordController.text);
                              Response serverResponse = await restult;
                              if (serverResponse.statusCode == 200) {
                                final jsonDecoded =
                                    json.decode(serverResponse.body);
                                User user = User.fromJson(jsonDecoded);
                                user.userName = _usernameCotroller.text;
                                user.password = _passwordController.text;
                                print(user.token);
                                savePrefs();
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) =>
                                      Dashboard(userInfo: user),
                                ));
                              } else {
                                printOutput(
                                    "Wystąpil problem, sprawdź swoje dane, lub spróbuj później",
                                    context);
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
                            "Zaloguj",
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
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (_) => new Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                              await startSignIn();
                            },
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
                                    "Zaloguj przez Google",
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
                              checkConnecton();
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
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkConnecton() {
    Future<bool> isConnected = api.makePing();
    if (isConnected == Future.value(false)) {
      print("Nie dziala");
      return showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text("Problem z polaczeniem do serwera"),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      'Ok',
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ]);
          });
    } else {
      print("Dziala");
      return Future.value(null);
    }
  }

  Future<void> startSignIn() async {
    GoogleSignInAccount user = await googleSignIn.signIn();
    if (user == null) {
      print("Failed");
    } else {
      print("Working");
      getProfile();
    }
    createAccount();
  }

  void getProfile() async {
    googleAccout = googleSignIn.currentUser;
    auth = await googleAccout.authentication;
  }

  void createAccount() async {
    await api.createUser(
      googleAccout.displayName,
      googleAccout.email,
      passwordForGoogleAccounts,
    );
    var result = api.loginUser(
      googleAccout.displayName,
      passwordForGoogleAccounts,
    );
    Response serverResponse = await result;
    if (serverResponse.statusCode == 200) {
      final jsonDecoded = json.decode(serverResponse.body);
      User user = User.fromJson(jsonDecoded);
      user.userName = googleAccout.displayName;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => Dashboard(userInfo: user),
      ));
    } else {
      printOutput(
          "Wystąpił bład, sprawdź swoje dane lub spróbuj później", context);
    }
  }

  void checkPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = (prefs.getString('username'));
    String password = (prefs.getString('password'));
    setState(() {
      _usernameCotroller.text = username;
      _passwordController.text = password;
    });
  }

  void savePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = _usernameCotroller.text;
    String password = _passwordController.text;
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }
}
