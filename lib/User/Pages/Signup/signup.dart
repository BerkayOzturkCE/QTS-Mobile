import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technical_services/User/Pages/MainMenu/mainmenu.dart';
import 'package:technical_services/User/Pages/Profile/ProfilePage.dart';
import 'package:technical_services/User/Pages/Signin/signin.dart';
import 'package:technical_services/User/Pages/Signup/Failed.dart';
import 'package:technical_services/User/Utils/functions.dart';
import 'package:technical_services/User/Widgets/widgets.dart';
import 'package:technical_services/User/data/data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  late User user;
  double width = 200.0;
  double widthIcon = 200.0;
  String mail = "";
  String password = "";
  bool obscuretxt = true;
  bool mailFocus = false;
  bool passwordFocus = false;

  void initState() {
    // TODO: implement initState
    super.initState();
    mailFocus = false;
    passwordFocus = false;
  }

  Future<void> getThemeData() async {
    final prefs = await SharedPreferences.getInstance();

    final bool? Theme = prefs.getBool('Theme');

    if (Theme == true) {
      ThemeType = "Dark";
      Theme_data().DarkThemeData();
    } else {
      ThemeType = "Light";
      Theme_data().LightThemeData();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getThemeData();
    return Page();
  }

  Widget Page() {
    return Scaffold(
      backgroundColor: ScaffoldColor,
      resizeToAvoidBottomInset: false,
      body: ThemeType == ""
          ? Center(
              child: Column(children: [
                SizedBox(
                  height: 80,
                ),
                CircularProgressIndicator(
                  backgroundColor: CircularLoadingIndicatorColor,
                ),
              ]),
            )
          : Login(),
    );
  }

  Widget Login() {
    bool oku = false;
    return Container(
        padding: EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 0, right: 30, left: 30),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                    height: 150,
                    width: 150,
                    child: ThemeType == "Dark"
                        ? Image.asset("assets/icons/logo.png")
                        : Image.asset("assets/icons/logo2.png"),
                  ),
                  Text(
                    "GİRİŞ YAPINIZ",
                    style: TextStyle(
                      fontSize: 35,
                      letterSpacing: 1,
                      color: TextColor,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextField(
                    autofocus: mailFocus,
                    style: TextStyle(
                      color: TextenterColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (String s) {
                      mail = s;
                    },
                    readOnly: oku,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.mail_outline,
                        color: TextenterColor,
                      ),
                      hintText: "E-Mail",
                      hintStyle: TextStyle(
                        fontSize: 18,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: TextfieldColor,
                      contentPadding: EdgeInsets.all(20),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextField(
                    autofocus: passwordFocus,
                    obscureText: true,
                    style: TextStyle(
                      color: TextenterColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (String s) {
                      password = s;
                    },
                    readOnly: oku,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock_outline_sharp,
                        color: TextenterColor,
                      ),
                      hintText: "Şifre",
                      hintStyle: TextStyle(
                        fontSize: 18,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: TextfieldColor,
                      contentPadding: EdgeInsets.all(20),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      MailGiris();
                    },
                    child: Container(
                      width: ScreenUtil.getWidth(context),
                      height: 60,
                      decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          "Giriş",
                          style: TextStyle(
                            fontSize: 25,
                            letterSpacing: 1,
                            color: TextColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "YADA",
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 1,
                      color: TextColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: buttonColor,
                            borderRadius: BorderRadius.circular(45)),
                        child: IconButton(
                          onPressed: () {
                            GoogleGiris();
                          },
                          icon: Icon(
                            FontAwesomeIcons.google,
                            color: TextColor,
                          ),
                          iconSize: 30,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: buttonColor,
                            borderRadius: BorderRadius.circular(45)),
                        child: IconButton(
                          onPressed: () {
                            signInWithFacebook();
                          },
                          icon: Icon(
                            FontAwesomeIcons.facebook,
                            color: TextColor,
                          ),
                          iconSize: 30,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: buttonColor,
                            borderRadius: BorderRadius.circular(45)),
                        child: IconButton(
                          onPressed: () {
                            GoogleGiris();
                          },
                          icon: Icon(
                            FontAwesomeIcons.twitter,
                            color: TextColor,
                          ),
                          iconSize: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 800),
                            child: SignUpPage()))
                    .then((value) {
                  Future.delayed(Duration(milliseconds: 300), () {
                    setState(() {
                      width = 200;
                      widthIcon = 200;
                    });
                  });
                });
                setState(() {
                  width = 500.0;
                  widthIcon = 0;
                });
              },
              child: AnimatedContainer(
                height: 65.0,
                width: width,
                duration: Duration(milliseconds: 1000),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: TextColor,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
//                          margin: EdgeInsets.only(right: 8,top: 15),
                            child: Text(
                              "Hesabınız Yok mu ?",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 1,
                                color: TextColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
//                          margin: EdgeInsets.only(right: 8,top: 15),
                            child: Text(
                              "Kayıt Olun",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 1,
                                color: TextColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                curve: Curves.linear,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    topLeft: Radius.circular(40),
                  ),
                  color: buttonColor,
                ),
              ),
            ),
          ],
        ));
  }

  void MailGiris() async {
    try {
      if (mail != "" && password != "") {
        UserCredential _credential = await _auth.signInWithEmailAndPassword(
            email: mail, password: password);
        user = _credential.user!;
        activeUser = user;
        if (user.emailVerified == true) {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MainMenu(user)))
              .then((value) => Navigator.pop(context));
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => FailedPage()));
        }
      } else {
        WarningWidget("Lütfen boş yerleri doldurun!", "Hata", context);
      }
    } catch (e) {
      WarningWidget(e.toString() + " hatası alındı.", "Hata", context);
    }
  }

  void GoogleGiris() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential _credential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      user = _credential.user!;
      activeUser = user;
      Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainMenu(user)))
          .then((value) => Navigator.pop(context));
    } catch (e) {
      WarningWidget(e.toString() + " hatası alındı.", "Hata", context);
    }
  }

  void signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      // Once signed in, return the UserCredential
      UserCredential _credential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);

      user = _credential.user!;
      activeUser = user;
      Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainMenu(user)))
          .then((value) => Navigator.pop(context));
    } catch (e) {
      WarningWidget(e.toString() + " hatası alındı.", "Hata", context);
    }
  }
}
