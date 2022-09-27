import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:technical_services/User/Pages/StoreDetails/Details.dart';
import 'package:technical_services/User/Utils/functions.dart';
import 'package:technical_services/User/data/Services.dart';
import 'package:technical_services/User/data/data.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchTextController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScaffoldColor,
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            TextField(
              controller: searchTextController,
              onChanged: (text) {
                setState(() {});
              },
              style: TextStyle(
                color: TextenterColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: "Ara",
                hintStyle: TextStyle(
                  fontSize: 16,
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
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(
                    left: 14,
                    right: 10,
                  ),
                  child: searchTextController.text == ""
                      ? GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: TextenterColor,
                            size: 30,
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              searchTextController.text = "";
                            });
                          },
                          child: Icon(
                            Icons.clear,
                            color: TextenterColor,
                            size: 25,
                          ),
                        ),
                ),
              ),
              autofocus: true,
            ),
            searchTextController.text != ""
                ? FutureBuilder<QuerySnapshot>(
                    future: _firestore
                        .collection("Services")
                        .where("City", isEqualTo: CurrentuserData.adres)
                        .where(
                          'SearchName',
                          isGreaterThanOrEqualTo:
                              searchTextController.text.toLowerCase(),
                          isLessThan: searchTextController.text
                                  .toLowerCase()
                                  .substring(
                                      0,
                                      searchTextController.text
                                              .toLowerCase()
                                              .length -
                                          1) +
                              String.fromCharCode(searchTextController.text
                                      .toLowerCase()
                                      .codeUnitAt(searchTextController.text
                                              .toLowerCase()
                                              .length -
                                          1) +
                                  1),
                        )
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Column(children: [
                            SizedBox(
                              height: 80,
                            ),
                            CircularProgressIndicator(
                              backgroundColor: CircularLoadingIndicatorColor,
                            ),
                          ]),
                        );
                      } else if (snapshot.hasError) {
                        return UyariText("Bir Hata Alındı");
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        if (snapshot.data!.docs.isEmpty) {
                          return UyariText("\"" +
                              searchTextController.text +
                              "\" İçin Sonuç Bulunamadı");
                        }
                        return ListView(
                          shrinkWrap: true,
                          children: snapshot.data!.docs
                              .map((snapshot) => ServiceWidget(snapshot))
                              .toList(),
                        );
                      } else {
                        return UyariText("\"" +
                            searchTextController.text +
                            "\" İçin Sonuç Bulunamadı");
                      }
                    },
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget UyariText(String text) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Text(
        text,
        style: TextStyle(color: TextColor, fontSize: 16),
      ),
    );
  }

  Widget ServiceWidget(QueryDocumentSnapshot snapshot) {
    Services services = ServiceData(snapshot);
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Activeservices = services;
            Navigator.of(context).push(
              MaterialPageRoute(
                settings: RouteSettings(name: "/Service"),
                builder: (context) => ServicesDetails(),
              ),
            );
          },
          child: Container(
              height: ScreenUtil.getHeight(context) / 10,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: BGColor2,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                    ),
                    child: Image.network(
                      services.Image,
                    ),
                  ),
                  Container(
                    width: ScreenUtil.getWidth(context) / 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          services.Name,
                          style: TextStyle(fontSize: 18, color: TextColor),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      height: ScreenUtil.getHeight(context) / 15,
                      width: ScreenUtil.getWidth(context) / 9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Functions().ColorDetecter(services.ortPuan)),
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
                              services.ortPuan.toStringAsFixed(2),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ))
                ],
              )),
        ),
        Divider(
          color: dividerColor,
          height: 1,
        ),
      ],
    );
  }

  Services ServiceData(QueryDocumentSnapshot snapshot) {
    Services services = new Services();

    services.Id = snapshot['Id'];
    services.Image = snapshot['Image'].toString();
    services.mah = snapshot['City'].toString();
    services.Name = snapshot['Name'].toString();
    services.category = snapshot['Category'].toString();
    services.ortPuan = double.parse(snapshot['OrtPuan'].toString());
    services.aciklama = snapshot['Aciklama'].toString();

    services.Fiyat = double.parse(snapshot['Fiyat'].toString());

    return services;
  }
}
