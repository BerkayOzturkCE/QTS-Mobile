import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:technical_services/User/Pages/CallsDetail/CallsDetail.dart';
import 'package:technical_services/User/Pages/Category/CategoryPage.dart';
import 'package:technical_services/User/Pages/ListPage/ListPage.dart';
import 'package:technical_services/User/Pages/Profile/ProfilePage.dart';
import 'package:technical_services/User/Pages/Search/search.dart';
import 'package:technical_services/User/Utils/functions.dart';
import 'package:technical_services/User/Widgets/widgets.dart';
import 'package:technical_services/User/data/Date.dart';
import 'package:technical_services/User/data/User.dart';
import 'package:technical_services/User/data/UserCalls.dart';
import 'package:technical_services/User/data/data.dart';
import 'package:technical_services/User/data/Services.dart';

class MainMenu extends StatefulWidget {
  MainMenu(this.user);
  User user;

  late UserData userdata = new UserData();
  bool drm = true;

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    Veri_Al();
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 25,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                widget.drm = true;
                setState(() {});
              },
              icon: Icon(Icons.replay)),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage(widget.user)))
                      .whenComplete(() {
                    setState(() {
                      widget.drm = true;
                    });
                  });
                },
                icon: Icon(Icons.person_outline))
          ],
          title: Text(
            "Anasayfa",
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
            : ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                    height: 100,
                    width: 100,
                    child: ThemeType == "Dark"
                        ? Image.asset("assets/icons/logo.png")
                        : Image.asset("assets/icons/logo2.png"),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        style: TextStyle(
                          color: TextenterColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        readOnly: true,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Search()));
                        },
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
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 12,
                            ),
                            child: Icon(
                              Icons.search,
                              color: TextenterColor,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    child: Container(
                      margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: BGColor1,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProfilePage(widget.user)))
                                  .whenComplete(() {
                                setState(() {
                                  widget.drm = true;
                                });
                              });
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(90),
                              child: Image.network(
                                widget.userdata.Image,
                                width: 52,
                                height: 52,
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
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: 280,
                            child: Column(
                              children: [
                                Container(
                                  width: 280,
                                  child: Text(
                                    widget.userdata.name.toString(),
                                    style: TextStyle(
                                        color: TextColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 280,
                                  child: Text(
                                    widget.userdata.adres,
                                    style: TextStyle(
                                        color: TextColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CategoryPage()));
                      },
                      child: Text(
                        "Servis Çağır",
                        style: TextStyle(fontSize: 25, color: TextColor),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(buttonColor),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: BGColor1,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.all(20),
                            child: Text(
                              "Eski Çağrılar",
                              style: TextStyle(
                                fontSize: 25,
                                color: TextColor,
                              ),
                            )),
                        ListView(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          children: callsList.isEmpty == true
                              ? [
                                  Center(
                                    child: Text(
                                      "Kayıt Bulunamadı",
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: TextColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  )
                                ]
                              : callsList
                                  .map((usercalls) => ListItemWidget(usercalls))
                                  .toList(),
                        )
                      ],
                    ),
                  )
                ],
              ));
  }

  Widget ListItemWidget(UserCalls userCallsItem) {
    return Container(
        height: ScreenUtil.getHeight(context) / 5,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: BGColor3,
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
                userCallsItem.Image,
              ),
            ),
            Container(
              width: ScreenUtil.getWidth(context) / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userCallsItem.Name,
                    style: TextStyle(fontSize: 18, color: TextColor),
                  ),
                  Text(
                    "Kategori:  " + userCallsItem.category,
                    style: TextStyle(color: TextColor, fontSize: 14),
                  ),
                  Text(
                    "Tarih:  " +
                        DateFormat('dd.MM.yyyy')
                            .format(userCallsItem.tarih)
                            .toString(),
                    style: TextStyle(color: TextColor, fontSize: 14),
                  ),
                  Text(
                    "Ücret:  " + userCallsItem.Fiyat.toString() + "₺",
                    style: TextStyle(color: TextColor, fontSize: 14),
                  ),
                ],
              ),
            ),
            Container(
              height: ScreenUtil.getHeight(context) / 15,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      settings: RouteSettings(name: "/UserCall"),
                      builder: (context) => CallsDetail(userCallsItem),
                    ),
                  );
                },
                child: Center(
                  child: Text(
                    "Ayrıntılar",
                    style: TextStyle(color: TextColor),
                  ),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                  buttonColor2,
                )),
              ),
            )
          ],
        ));
  }

  Future Veri_Al() async {
    try {
      if (widget.drm == true) {
        var veriler = await _firestore
            .collection("Users")
            .where("Id", isEqualTo: widget.user.uid)
            .get();

        if (veriler.size == 0) {
          AddFirestore();
          setState(() {});
          return;
        }

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

          user.tel = veri.get("Tel").toString();
          widget.userdata = user;
          CurrentuserData = user;
          if (CurrentuserData.adres == "") {
            String city = await getLocation();
            await _firestore
                .collection("Users")
                .doc(widget.user.uid)
                .update({'Adres': Cryptology().Encryption(city, context)});
            setState(() {});
            return;
          }

          callsList.clear();
          var veriler = await _firestore
              .collection("Calls")
              .where("UserId", isEqualTo: activeUser.uid)
              .orderBy("Tarih", descending: true)
              .get();

          for (var veri in veriler.docs) {
            UserCalls userCalls = new UserCalls();

            debugPrint(veri.data().toString());

            userCalls.Id = veri.get("Id").toString();
            userCalls.Image =
                Cryptology().Decryption(veri.get("Image").toString(), context);
            Timestamp tarih = veri.get("Tarih");
            userCalls.tarih = tarih.toDate();
            userCalls.Name =
                Cryptology().Decryption(veri.get("Name").toString(), context);
            userCalls.category = Cryptology()
                .Decryption(veri.get("Category").toString(), context);
            userCalls.Fiyat = double.parse(
                Cryptology().Decryption(veri.get("Fiyat").toString(), context));
            userCalls.ServiceId = veri.get("ServiceId");
            userCalls.UserId = veri.get("UserId");
            userCalls.adres =
                Cryptology().Decryption(veri.get("Adres"), context);
            userCalls.apt = Cryptology().Decryption(veri.get("Apt"), context);
            userCalls.kat = Cryptology().Decryption(veri.get("Kat"), context);
            userCalls.no = Cryptology().Decryption(veri.get("No"), context);
            userCalls.lat = double.parse(
                Cryptology().Decryption(veri.get("Lat").toString(), context));
            userCalls.lon = double.parse(
                Cryptology().Decryption(veri.get("Lon").toString(), context));

            callsList.add(userCalls);
          }

          if (this.mounted) {
            setState(() {
              widget.drm = false;
            });
          }
        }
      }
    } catch (e) {
      print(e.toString());
      WarningWidget(e.toString() + " Hatası alındı", "Hata", context);
    }
  }

  void AddFirestore() async {
    try {
      activeUser.updatePhotoURL(
          "https://firebasestorage.googleapis.com/v0/b/technicalservices-2973a.appspot.com/o/images%2Fdata%2Fuser%2F0%2Fcom.example.technical_services%2Fcache%2Fimage_picker2225952379780568151.png?alt=media&token=9a19b135-3899-4278-a90e-9a328b18a9ea");
      await AddData();
    } catch (e) {
      WarningWidget(e.toString(), "Hata", context);
    }
  }

  Future<void> AddData() async {
    // ignore: await_only_futures
    try {
      DocumentReference ref =
          FirebaseFirestore.instance.collection("Users").doc(activeUser.uid);
      String foodId;
      Map<String, dynamic> eklenecek = Map();
      eklenecek["Id"] = activeUser.uid;
      eklenecek["Adres"] = Cryptology().Encryption("", context);
      eklenecek["Name"] =
          Cryptology().Encryption(activeUser.displayName.toString(), context);

      eklenecek["Image"] = Cryptology().Encryption(
          "https://firebasestorage.googleapis.com/v0/b/technicalservices-2973a.appspot.com/o/images%2Fdata%2Fuser%2F0%2Fcom.example.technical_services%2Fcache%2Fimage_picker2225952379780568151.png?alt=media&token=9a19b135-3899-4278-a90e-9a328b18a9ea",
          context);
      eklenecek["Tel"] = Cryptology().Encryption("", context);

      ref.set(eklenecek);
    } catch (error) {
      WarningWidget(error.toString(), "Hata", context);
    }
  }

  Future<String> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position knm = await Geolocator.getCurrentPosition();

    final coordinates = new Coordinates(knm.latitude, knm.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);

    String city = addresses.first.adminArea;
    print(city);
    return city;
  }
}
