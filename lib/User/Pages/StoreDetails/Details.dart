import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:technical_services/User/Pages/Chat/chat.dart';
import 'package:technical_services/User/Pages/Map/maps.dart';
import 'package:technical_services/User/Utils/functions.dart';
import 'package:technical_services/User/Widgets/widgets.dart';
import 'package:technical_services/User/data/Rate.dart';
import 'package:technical_services/User/data/data.dart';
import 'package:technical_services/User/data/Services.dart';
import 'package:unicons/unicons.dart';

class ServicesDetails extends StatefulWidget {
  ServicesDetails();

  @override
  _ServicesDetailsState createState() => _ServicesDetailsState();
  late bool drm = true;
  List<RateModel> CommentList = [];
}

class _ServicesDetailsState extends State<ServicesDetails> {
  @override
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Widget build(BuildContext context) {
    GetCommentFromFireStore();
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 25,
          elevation: 0,
          title: Text(
            Activeservices.Name,
            style: TextStyle(
              color: TextColor,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: IconButton(
                color: TextColor,
                splashColor: dividerColor,
                icon: Icon(UniconsLine.facebook_messenger_alt),
                iconSize: 27,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChatPage()));
                },
              ),
            ),
          ],
          foregroundColor: TextColor,
          toolbarHeight: 60,
          backgroundColor: AppbarColor,
        ),
        backgroundColor: ScaffoldColor,
        body: widget.drm == true
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: CircularLoadingIndicatorColor,
                ),
              )
            : ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: [
                  Container(
                    margin: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: ScreenUtil.getWidth(context) / 4,
                              child: Image.network(
                                Activeservices.Image,
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
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                Container(
                                  width: ScreenUtil.getWidth(context) / 2.5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Activeservices.Name,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: TextColor,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Konum:  " + Activeservices.mah,
                                        style: TextStyle(
                                            color: TextColor, fontSize: 14),
                                      ),
                                      Text(
                                        "Kategori:  " + Activeservices.category,
                                        style: TextStyle(
                                            color: TextColor, fontSize: 14),
                                      ),
                                      Text(
                                        "Servis Ücreti:  " +
                                            Activeservices.Fiyat.toString() +
                                            "₺",
                                        style: TextStyle(
                                            color: TextColor, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                Container(
                                    height: ScreenUtil.getHeight(context) / 15,
                                    width: ScreenUtil.getWidth(context) / 9,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Functions()
                                            .ColorDetecter(AverageCalculate())),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Puan",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                          Text(
                                            AverageCalculate()
                                                .toStringAsFixed(2),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                TextButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                    buttonColor,
                                  )),
                                  child: Text(
                                    'Servis Çağır',
                                    style: TextStyle(color: TextColor),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        settings: RouteSettings(name: "/MyMap"),
                                        builder: (context) => MyMap(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          color: dividerColor,
                          height: 2,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: ExpansionTile(
                            title: Text(
                              "Açıklama",
                              style: TextStyle(
                                color: TextColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            iconColor: TextColor,
                            collapsedIconColor: TextColor,
                            backgroundColor: BGColor2,
                            collapsedBackgroundColor: BGColor2,
                            children: [
                              Container(
                                  margin: EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        Activeservices.aciklama,
                                        style: TextStyle(
                                          color: TextColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.all(14),
                          child: Text(
                            "Yorumlar",
                            style: TextStyle(
                              color: TextColor,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        widget.CommentList.isEmpty == true
                            ? Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "Yorum Bulunamadı!!!",
                                  style:
                                      TextStyle(color: TextColor, fontSize: 18),
                                ),
                              )
                            : Container(
                                child: ListView(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  children: widget.CommentList.map(
                                          (ratemodel) => comment(ratemodel))
                                      .toList(),
                                ),
                              ),
                      ],
                    ),
                  )
                ],
              ));
  }

  Widget comment(RateModel rateModel) {
    return Container(
      width: ScreenUtil.getWidth(context) / 1.2,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: BGColor2, borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                rateModel.UserName,
                style: TextStyle(
                  color: TextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Text(
                DateFormat('dd.MM.yyyy\nHH.mm')
                    .format(rateModel.date)
                    .toString(),
                style: TextStyle(color: TextColor, fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: ScreenUtil.getWidth(context) / 1.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rateModel.Comment,
                      style: TextStyle(
                        color: TextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      height: ScreenUtil.getHeight(context) / 15,
                      width: ScreenUtil.getWidth(context) / 9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Functions()
                              .ColorDetecter(rateModel.RateCount.toDouble())),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Puan",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            Text(
                              rateModel.RateCount.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      )),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  void GetCommentFromFireStore() async {
    try {
      if (widget.drm == true) {
        widget.CommentList.clear();
        var veriler = await _firestore
            .collection("Ratings")
            .where("ServiceId", isEqualTo: Activeservices.Id)
            .orderBy("Date", descending: true)
            .get();

        for (var veri in veriler.docs) {
          RateModel rateModel = new RateModel();
          rateModel.CallId = veri.get("CallId").toString();
          rateModel.Comment =
              Cryptology().Decryption(veri.get("Comment").toString(), context);
          rateModel.UserName =
              Cryptology().Decryption(veri.get("UserName").toString(), context);
          rateModel.RateCount = int.parse(
              Cryptology().Decryption(veri.get("RateCount"), context));
          rateModel.ServiceId = veri.get("ServiceId").toString();
          rateModel.UserId = veri.get("UserId").toString();
          Timestamp date = veri.get("Date");
          rateModel.date = date.toDate();
          rateModel.UserName = NameSecret(rateModel.UserName);
          widget.CommentList.add(rateModel);
        }
        setState(() {
          widget.drm = false;
        });
      }
    } catch (e) {
      print(e.toString());
      WarningWidget(e.toString() + " Hatası alındı!", "Hata", context);
    }
  }

  String NameSecret(String Name) {
    var NameList = Name.split(" ");
    String NameSecret = "";
    for (var i = 0; i < NameList.length; i++) {
      String nameTemp = NameList[i][0];

      for (var j = 1; j < NameList[i].length; j++) {
        nameTemp += "*";
      }
      NameList[i] = nameTemp;
      NameSecret += NameList[i];
      NameSecret += " ";
    }
    return NameSecret;
  }

  double AverageCalculate() {
    double Average = 0.0;

    for (var i = 0; i < widget.CommentList.length; i++) {
      Average += widget.CommentList[i].RateCount;
    }
    return (Average / widget.CommentList.length);
  }
}
