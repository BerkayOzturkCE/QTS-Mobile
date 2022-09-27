import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:technical_services/User/Utils/functions.dart';
import 'package:technical_services/User/Widgets/widgets.dart';
import 'package:technical_services/User/data/Rate.dart';
import 'package:technical_services/User/data/Services.dart';
import 'package:technical_services/User/data/data.dart';

class RatingPage extends StatefulWidget {
  int rate = 0;
  RateModel rateModel;
  RatingPage(this.rateModel);
  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  TextEditingController CommentCont = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 25,
        elevation: 0,
        title: Text(
          "Değerlendir",
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
      body: ListView(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(10),
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                  color: BGColor1,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: Image.network(
                          CurrentuserData.Image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                backgroundColor: CircularLoadingIndicatorColor,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        activeUser.displayName!,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: TextColor),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Değerlendirmeniz " + widget.rate.toString() + "/10",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w500, color: TextColor),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                margin: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RatingBar(
                      itemSize: 35,
                      itemCount: 5,
                      allowHalfRating: true,
                      ratingWidget: RatingWidget(
                        full: Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        half: Icon(
                          Icons.star_half,
                          color: Colors.amber,
                        ),
                        empty: Icon(
                          Icons.star_border,
                          color: Colors.amber,
                        ),
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                        widget.rate = (rating * 2).toInt();
                        setState(() {});
                      },
                    ),
                  ],
                )),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: TextField(
                maxLines: 5,
                controller: CommentCont,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  /*suffixIcon:
                          IconButton(onPressed: () {}, icon: Icon(Icons.visibility_off),padding: EdgeInsets.all(),),*/
                  hintText: "Yorumunuz",
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
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: buttonColor2,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextButton(
                onPressed: () {
                  Kaydet();
                },
                child: Text(
                  "Değerlendirmeyi Kaydet",
                  style: TextStyle(fontSize: 20, color: TextColor),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(buttonColor2),
                ),
              ),
            )
          ],
        ),
      ]),
    );
  }

  Future<void> Kaydet() async {
    try {
      widget.rateModel.Comment = CommentCont.text;
      widget.rateModel.RateCount = widget.rate;
      widget.rateModel.date = DateTime.now();
      widget.rateModel.UserName = CurrentuserData.name;
      showLoaderDialog(context);
      DocumentReference ref =
          FirebaseFirestore.instance.collection("Ratings").doc();

      Map<String, dynamic> eklenecek = Map();
      eklenecek["ServiceId"] = widget.rateModel.ServiceId;
      eklenecek["UserId"] = widget.rateModel.UserId;
      eklenecek["CallId"] = widget.rateModel.CallId;

      eklenecek["Comment"] =
          Cryptology().Encryption(widget.rateModel.Comment, context);
      eklenecek["UserName"] =
          Cryptology().Encryption(widget.rateModel.UserName, context);
      eklenecek["RateCount"] = Cryptology()
          .Encryption(widget.rateModel.RateCount.toString(), context);
      eklenecek["Date"] = widget.rateModel.date;
      print("object");
      var getdata = await _firestore
          .collection("Services")
          .doc(widget.rateModel.ServiceId)
          .get();

      var veri = getdata;
      Services services = new Services();

      debugPrint(veri.data().toString());

      services.Id = veri.get("Id").toString();
      services.Image = veri.get("Image").toString();
      services.mah = veri.get("City").toString();
      services.Name = veri.get("Name").toString();
      services.category = veri.get("Category").toString();
      services.ortPuan = double.parse(veri.get("OrtPuan").toString());
      services.aciklama = veri.get("Aciklama").toString();
      services.CommantCount = veri.get("CommantCount");
      services.Fiyat = double.parse(veri.get("Fiyat").toString());
      double newAverage = services.ortPuan * services.CommantCount;
      newAverage += widget.rateModel.RateCount;
      services.CommantCount += 1;
      newAverage = newAverage / services.CommantCount;
      services.ortPuan = newAverage;
      print("--------------------------------------------");
      print(services.Id);
      print(widget.rateModel.ServiceId);
      await _firestore
          .collection("Services")
          .doc(widget.rateModel.ServiceId)
          .update({"OrtPuan": services.ortPuan});
      await _firestore
          .collection("Services")
          .doc(widget.rateModel.ServiceId)
          .update({"CommantCount": services.CommantCount});

      ref.set(eklenecek).whenComplete(() {
        Navigator.pop(context);
        WarningWidgetWait("İşlem Başarılı", "Başarılı", context, "/UserCall");
      });
    } catch (e) {
      Navigator.pop(context);
      WarningWidget(e.toString() + " hatası alındı", "Hata", context);
    }
  }
}
