import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:technical_services/User/Pages/StoreDetails/Details.dart';
import 'package:technical_services/User/Utils/functions.dart';
import 'package:technical_services/User/data/data.dart';
import 'package:technical_services/User/data/Services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ListPage extends StatefulWidget {
  List<Services> ServiceList = [];

  ListPage(this.tur);
  String tur;
  bool drm = true;
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    Veri_Al();
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 25,
          elevation: 0,
          centerTitle: false,
          title: Text(widget.tur),
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
            : ListView(
                children: widget.ServiceList.isEmpty == true
                    ? [
                        Center(
                          heightFactor: 10,
                          child: Text(
                            "Veri yok",
                            style: TextStyle(color: TextColor, fontSize: 30),
                          ),
                        )
                      ]
                    : widget.ServiceList.map(
                        (Service) => ListItemWidget(Service)).toList(),
              ));
  }

  Widget ListItemWidget(Services services) {
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
              height: ScreenUtil.getHeight(context) / 5,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: BGColor2,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                    ),
                    child: Image.network(
                      services.Image,
                    ),
                  ),
                  Container(
                    width: ScreenUtil.getWidth(context) / 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          services.Name,
                          style: TextStyle(fontSize: 18, color: TextColor),
                        ),
                        Text(
                          "Konum:  " + services.mah,
                          style: TextStyle(color: TextColor, fontSize: 14),
                        ),
                        Text(
                          "Kategori:  " + services.category,
                          style: TextStyle(color: TextColor, fontSize: 14),
                        ),
                        Text(
                          "Servis Ücreti:  " + services.Fiyat.toString() + "₺",
                          style: TextStyle(color: TextColor, fontSize: 14),
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
                              services.ortPuan.toString(),
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

  Future Veri_Al() async {
    if (widget.drm == true) {
      widget.ServiceList.clear();
      var veriler;
      if (widget.tur == "Hepsi") {
        veriler = await _firestore
            .collection("Services")
            .where("City", isEqualTo: CurrentuserData.adres)
            .get();
      } else {
        veriler = await _firestore
            .collection("Services")
            .where("Category", isEqualTo: widget.tur)
            .where("City", isEqualTo: CurrentuserData.adres)
            .get();
      }

      for (var veri in veriler.docs) {
        Services services = new Services();

        debugPrint(veri.data().toString());

        services.Id = veri.get("Id").toString();
        services.Image = veri.get("Image").toString();
        services.mah = veri.get("City").toString();
        services.Name = veri.get("Name").toString();
        services.category = veri.get("Category").toString();
        services.ortPuan = double.parse(veri.get("OrtPuan").toStringAsFixed(2));
        services.aciklama = veri.get("Aciklama").toString();
        services.CommantCount = veri.get("CommantCount");

        services.Fiyat = double.parse(veri.get("Fiyat").toString());
        widget.ServiceList.add(services);
      }
      if (this.mounted) {
        setState(() {
          widget.drm = false;
        });
      }
      ;
    }
  }
}
