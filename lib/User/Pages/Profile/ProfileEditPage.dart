import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:technical_services/User/Utils/functions.dart';
import 'package:technical_services/User/Widgets/widgets.dart';
import 'package:technical_services/User/data/City.dart';
import 'package:technical_services/User/data/User.dart';
import 'package:technical_services/User/data/data.dart';

class ProfileEditPage extends StatefulWidget {
  ProfileEditPage(this.user, this.userData);
  User user;
  UserData userData;

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  String name = "";
  String mail = "";
  String adres = "";
  String Telnumber = "";
  String CityName = "Şehir seçiniz";
  bool oku = false;
  void initState() {
    CityName = widget.userData.adres;
    name = widget.userData.name;
    mail = widget.user.email.toString();
    adres = widget.userData.adres;
    Telnumber = widget.userData.tel;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController mailcontroller = TextEditingController();
  TextEditingController adrescontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();

  Widget build(BuildContext context) {
    namecontroller.text = name;
    mailcontroller.text = mail;
    phonecontroller.text = Telnumber;
    namecontroller.selection = TextSelection.fromPosition(
        TextPosition(offset: namecontroller.text.length));

    adrescontroller.selection = TextSelection.fromPosition(
        TextPosition(offset: adrescontroller.text.length));

    phonecontroller.selection = TextSelection.fromPosition(
        TextPosition(offset: phonecontroller.text.length));

    return Scaffold(
        appBar: AppBar(
          titleSpacing: 25,
          elevation: 0,
          centerTitle: false,
          title: Text(
            "Düzenle",
            style: TextStyle(
              color: TextColor,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          foregroundColor: TextColor,
          toolbarHeight: 60,
          backgroundColor: AppbarColor,
        ),
        backgroundColor: ScaffoldColor,
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: 50, bottom: 40, right: 30, left: 30),
                    child: Column(
                      children: [
                        Text(
                          "Düzenle",
                          style: TextStyle(
                            fontSize: 40,
                            letterSpacing: 1,
                            color: TextColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        TextField(
                          controller: namecontroller,
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
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.all(20),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextField(
                          controller: mailcontroller,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          onChanged: (String s) {
                            mail = s;
                          },
                          readOnly: oku,
                          decoration: InputDecoration(
                            enabled: false,
                            prefixIcon: Icon(
                              Icons.mail_outline_outlined,
                              color: Colors.black,
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
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.all(20),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextField(
                          controller: phonecontroller,
                          obscureText: false,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(
                            color: Colors.black,
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
                              color: Colors.black,
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
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.all(20),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 230,
                              padding: EdgeInsets.only(
                                  left: 10, right: 0, top: 7, bottom: 7),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: DropdownButton<String>(
                                autofocus: true,
                                elevation: 1,
                                underline: SizedBox(),
                                dropdownColor: Colors.grey[200],
                                items: City().CityList.map((secili) {
                                  return DropdownMenuItem(
                                    child: Row(
                                      children: [
                                        Icon(Icons.home_outlined),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          secili,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    value: secili,
                                  );
                                }).toList(),
                                onChanged: (var deger) {
                                  setState(() {
                                    adres = deger.toString();
                                    CityName = deger.toString();
                                  });
                                },
                                value: CityName,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        GestureDetector(
                          onTap: () {
                            Guncelle();
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
                                "Güncelle",
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
                ],
              ),
            )
          ],
        ));
  }

  Future<void> Guncelle() async {
    try {
      if (namecontroller.text.isEmpty != true &&
          phonecontroller.text.isEmpty != true) {
        await _firestore
            .collection("Users")
            .doc(widget.user.uid)
            .update({'Adres': Cryptology().Encryption(adres, context)});

        _firestore.collection("Users").doc(widget.user.uid).update(
            {'Tel': Cryptology().Encryption(phonecontroller.text, context)});

        _firestore.collection("Users").doc(widget.user.uid).update({
          'Name': Cryptology().Encryption(namecontroller.text, context)
        }).whenComplete(() => WarningWidget(
            "Bilgiler Başarıyla Güncellendi", "Başarılı", context));
      } else {
        WarningWidget("Boş Alanları doldurun", "Hata", context);
      }
    } catch (e) {
      WarningWidget(e.toString() + " Hatası alındı", "Hata", context);
    }
  }
}
