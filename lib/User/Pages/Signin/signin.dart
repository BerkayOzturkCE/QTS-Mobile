import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:technical_services/User/Utils/functions.dart';
import 'package:technical_services/User/Widgets/widgets.dart';
import 'package:technical_services/User/data/data.dart';

class SignUpPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<SignUpPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  double width = 400.0;
  double widthIcon = 200.0;
  String name = "";
  String mail = "";
  String password = "";
  String Telnumber = "";
  Icon _icon = Icon(Icons.visibility_off);

  late PageController _pageController;

  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        width = 190.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Page();
  }

  Widget Page() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ScaffoldColor,
      body: Signup(),
    );
  }

  Widget Signup() {
    bool oku = false;
    return Container(
      padding: EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 55, bottom: 40, right: 30, left: 30),
            child: Column(
              children: [
                Text(
                  "KAYIT OL",
                  style: TextStyle(
                    fontSize: 35,
                    letterSpacing: 1,
                    color: TextColor,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                TextField(
                  style: TextStyle(
                    color: TextenterColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  onChanged: (String s) {
                    name = s;
                  },
                  readOnly: oku,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: TextenterColor,
                    ),
                    hintText: "İsim",
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
                      Icons.mail_outline_outlined,
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
                    /*suffixIcon:
                        IconButton(onPressed: () {}, icon: Icon(Icons.visibility_off),padding: EdgeInsets.all(),),*/
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
                TextField(
                  obscureText: false,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(
                    color: TextenterColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  onChanged: (String s) {
                    Telnumber = s;
                  },
                  readOnly: oku,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.phone_outlined,
                      color: TextenterColor,
                    ),
                    hintText: "Telefon Numarası",
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
                  height: 50,
                ),
                GestureDetector(
                  onTap: () {
                    Kaydol();
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
                        "Kayıt Ol",
                        style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 1,
                          color: TextColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(
                  context,
                  PageTransition(
                    type: PageTransitionType.leftToRight,
                    duration: Duration(milliseconds: 800),
                    child: SizedBox(),
                  ));
              setState(() {
                width = 500;
                widthIcon = 0;
              });
            },
            child: AnimatedContainer(
              height: 65.0,
              width: width,
              duration: Duration(milliseconds: 1000),
              curve: Curves.linear,
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Hesabınız Var mı ?",
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
                          child: Text(
                            "Giriş Yapın",
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
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: TextColor,
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: buttonColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void Kaydol() async {
    try {
      if (name != "" || mail != "" && password != "" && Telnumber != "") {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: mail, password: password);
        User? _newUser = credential.user;
        _newUser?.updateDisplayName(name);
        _newUser!.updatePhotoURL(
            "https://firebasestorage.googleapis.com/v0/b/technicalservices-2973a.appspot.com/o/images%2Fdata%2Fuser%2F0%2Fcom.example.technical_services%2Fcache%2Fimage_picker2225952379780568151.png?alt=media&token=9a19b135-3899-4278-a90e-9a328b18a9ea");
        await ekle(_newUser);
        _newUser.sendEmailVerification;
        WarningWidget("Kayıt İşlemi Başarılı.", "Başarılı", context);

        print(_newUser.toString());
      } else {
        WarningWidget("Lütfen boş alanları doldurun.", "Başarısız", context);
      }
    } catch (e) {
      WarningWidget(e.toString(), "Hata", context);
    }
  }

  Future<void> ekle(User user) async {
    // ignore: await_only_futures
    try {
      DocumentReference ref =
          FirebaseFirestore.instance.collection("Users").doc(user.uid);
      String foodId;
      Map<String, dynamic> eklenecek = Map();
      eklenecek["Id"] = user.uid;
      eklenecek["Adres"] = Cryptology().Encryption("", context);
      eklenecek["Name"] = Cryptology().Encryption(name, context);

      eklenecek["Image"] = Cryptology().Encryption(
          "https://firebasestorage.googleapis.com/v0/b/technicalservices-2973a.appspot.com/o/images%2Fdata%2Fuser%2F0%2Fcom.example.technical_services%2Fcache%2Fimage_picker2225952379780568151.png?alt=media&token=9a19b135-3899-4278-a90e-9a328b18a9ea",
          context);
      eklenecek["Tel"] = Cryptology().Encryption(Telnumber, context);

      ref.set(eklenecek);
    } catch (error) {
      WarningWidget(error.toString(), "Hata", context);
    }
  }
}
