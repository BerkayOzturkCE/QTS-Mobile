// ignore: file_names
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:technical_services/User/Pages/Profile/ProfileEditPage.dart';
import 'package:technical_services/User/Utils/functions.dart';
import 'package:technical_services/User/Widgets/widgets.dart';
import 'package:technical_services/User/data/User.dart';
import 'package:technical_services/User/data/data.dart';

class ProfilePage extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  late User _user;
  late UserData userData = new UserData();
  late bool drm = true;

  ProfilePage(this._user);
  @override
  _ProfilePageState createState() => _ProfilePageState();

  late String NewData = "";
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  late bool refresh = true;

  bool drm = true;
  void yenile() {
    widget.drm = true;
    widget._user.reload;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Veri_Al();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 25,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProfileEditPage(widget._user, widget.userData)))
                  .then((value) => yenile());
            },
            icon: Icon(
              Icons.edit_sharp,
              color: TextColor,
            ),
            color: TextColor,
          ),
          IconButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();

              if (ThemeType != "Dark") {
                await prefs.setBool('Theme', true);

                Theme_data().DarkThemeData();
                setState(() {});
              } else {
                await prefs.setBool('Theme', false);

                Theme_data().LightThemeData();
                setState(() {});
              }
            },
            icon: ThemeType == "Dark"
                ? Icon(
                    Icons.dark_mode,
                    color: TextColor,
                  )
                : Icon(
                    Icons.light_mode,
                    color: TextColor,
                  ),
            color: TextColor,
          )
        ],
        title: Text(
          "Profil",
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
      body: widget.drm == true
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
          : Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 350, top: 10),
                  child: Column(
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            photo_url_al();
                          },
                          child: ClipOval(
                            child: Image.network(
                              widget.userData.Image,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor:
                                        CircularLoadingIndicatorColor,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        widget.userData.name.toString(),
                        style: TextStyle(
                            color: TextColor,
                            fontSize: 30,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                SlidingUpPanel(
                  backdropColor: BGColor1!,
                  minHeight: 400,
                  maxHeight: 700,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                  panel: Container(
                    decoration: BoxDecoration(
                      color: BGColor1,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50)),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Bilgilerim",
                          style: TextStyle(
                              color: TextColor,
                              fontSize: 30,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Divider(
                          color: dividerColor,
                          height: 2,
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                  margin: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.person_outline,
                                    size: 30,
                                    color: TextColor,
                                  )),
                              Container(
                                  width: 320,
                                  child: Row(
                                    children: [
                                      Text(
                                        "İsim: ",
                                        style: TextStyle(
                                            color: TextColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            children: [
                                              Text(
                                                widget.userData.name.toString(),
                                                style: TextStyle(
                                                    color: TextColor,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                overflow: TextOverflow.fade,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        Divider(
                          color: dividerColor,
                          height: 2,
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                  margin: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.mail_outline,
                                    color: TextColor,
                                    size: 30,
                                  )),
                              Container(
                                  width: 320,
                                  child: Row(
                                    children: [
                                      Text(
                                        "E-mail: ",
                                        style: TextStyle(
                                            color: TextColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            children: [
                                              Text(
                                                widget._user.email.toString(),
                                                style: TextStyle(
                                                    color: TextColor,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                overflow: TextOverflow.fade,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        Divider(
                          color: dividerColor,
                          height: 2,
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                  margin: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.phone_outlined,
                                    color: TextColor,
                                    size: 30,
                                  )),
                              Container(
                                  width: 320,
                                  child: Row(
                                    children: [
                                      Text(
                                        "Telefon: ",
                                        style: TextStyle(
                                            color: TextColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            children: [
                                              Text(
                                                widget.userData.tel,
                                                style: TextStyle(
                                                    color: TextColor,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                overflow: TextOverflow.fade,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        Divider(
                          color: dividerColor,
                          height: 2,
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                  margin: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.home_outlined,
                                    color: TextColor,
                                    size: 30,
                                  )),
                              Container(
                                  width: 320,
                                  child: Row(
                                    children: [
                                      Text(
                                        "Adres: ",
                                        style: TextStyle(
                                            color: TextColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            children: [
                                              Text(
                                                widget.userData.adres,
                                                style: TextStyle(
                                                    color: TextColor,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                overflow: TextOverflow.fade,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        Divider(
                          color: dividerColor,
                          height: 2,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }

  void initState() {
    if (refresh == true) {
      refresh = false;
      widget._user.reload();
      super.initState();
    }
  }

  Future photo_url_al() async {
    try {
      String resimUrl;
      var resim = await ImagePicker()
          .pickImage(source: ImageSource.gallery)
          .onError((error, stackTrace) => null);
      showLoaderDialog(context);
      if (resim != null) {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child("images")
            .child(resim.path);
        firebase_storage.UploadTask uploadTask = ref.putFile(File(resim.path));

        debugPrint(resim.path);

        resimUrl =
            await (await uploadTask.whenComplete(() => Navigator.pop(context)))
                .ref
                .getDownloadURL();
        debugPrint(resimUrl);
        await _firestore
            .collection("Users")
            .doc(widget._user.uid)
            .update({'Image': Cryptology().Encryption(resimUrl, context)})
            .whenComplete(() =>
                WarningWidget("Fotoğraf Güncellendi", "Başarılı", context))
            .onError((error, stackTrace) =>
                WarningWidget("Fotoğraf güncellenemedi", "Başarısız", context))
            .timeout(Duration(seconds: 10));
        widget.drm = true;
        setState(() {});
      }
    } catch (error) {
      print(error);
    }
  }

  Future Veri_Al() async {
    if (widget.drm == true) {
      var veriler = await _firestore
          .collection("Users")
          .where("Id", isEqualTo: widget._user.uid)
          .get();

      for (var veri in veriler.docs) {
        UserData user = new UserData();

        debugPrint(veri.data().toString());

        user.id = veri.get("Id").toString();
        user.Image =
            Cryptology().Decryption(veri.get("Image").toString(), context);
        user.adres =
            Cryptology().Decryption(veri.get("Adres").toString(), context);
        user.name =
            Cryptology().Decryption(veri.get("Name").toString(), context);

        user.tel = Cryptology().Decryption(veri.get("Tel"), context);
        widget.userData = user;

        if (this.mounted) {
          setState(() {
            widget.drm = false;
          });
        }
        ;
      }
    }
  }
}
