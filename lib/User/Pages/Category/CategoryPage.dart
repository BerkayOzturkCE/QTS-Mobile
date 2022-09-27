import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:technical_services/User/Pages/ListPage/ListPage.dart';
import 'package:technical_services/User/data/data.dart';
// ignore: unused_import

//import 'package:loadmore/loadmore.dart';

class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 25,
        elevation: 0,
        centerTitle: false,
        title: Text("Kategoriler"),
        foregroundColor: TextColor,
        toolbarHeight: 60,
        backgroundColor: AppbarColor,
      ),
      backgroundColor: ScaffoldColor,
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: GridView.count(
                physics: BouncingScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
                children: <Widget>[
                  Kategori("Hepsi", context),
                  Kategori("Beyaz Eşya", context),
                  Kategori("Bilgisayar", context),
                  Kategori("Elektronik", context),
                  Kategori("Klima", context),
                  Kategori("Su Tesisatı", context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget Kategori(String tur, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ListPage(tur)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: BGColor2,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Center(
          child: Text(
            tur,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: TextColor,
            ),
          ),
        ),
      ),
    );
  }
}
