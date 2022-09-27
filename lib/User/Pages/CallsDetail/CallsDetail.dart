import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:technical_services/User/Pages/CallsDetail/Rating.dart';
import 'package:technical_services/User/Pages/Chat/chat.dart';
import 'package:technical_services/User/Utils/functions.dart';
import 'package:technical_services/User/Widgets/widgets.dart';
import 'package:technical_services/User/data/Rate.dart';
import 'package:technical_services/User/data/UserCalls.dart';
import 'package:technical_services/User/data/data.dart';
import 'package:geocoder/geocoder.dart';

class CallsDetail extends StatefulWidget {
  double latitude = 39.9286596, longitude = 32.8306459;
  UserCalls userCallsItem;
  CallsDetail(this.userCallsItem);
  String adresDetail = "";
  bool durum = true;
  RateModel? myRate;

  @override
  _CallsDetailsState createState() => _CallsDetailsState();
}

class _CallsDetailsState extends State<CallsDetail> {
  late GoogleMapController _controller;
  Set<Marker> markers = {};
  TextEditingController katcontroller = TextEditingController();
  TextEditingController aptcontroller = TextEditingController();
  TextEditingController adrescontroller = TextEditingController();
  TextEditingController nocontroller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _getCurrentLocation() async {
    widget.latitude = widget.userCallsItem.lat;
    widget.longitude = widget.userCallsItem.lon;
  }

  void onmapcreated() {
    if (ThemeType == "Dark") {
      _controller.setMapStyle(util.DarkmapStyle);
    } else {
      _controller.setMapStyle(util.LightmapStyle);
    }
    markers.clear;
    setState(() {
      markers.add(Marker(
          markerId: MarkerId("id-1"),
          position: LatLng(widget.latitude, widget.longitude)));
    });
  }

  @override
  Widget build(BuildContext context) {
    getAdress();
    getMyRate();

    _getCurrentLocation();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 25,
        elevation: 0,
        actions: [],
        title: Text(
          "Çağrı Detayı",
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
      body: Container(
        child: ListView(
          children: [
            Container(
              width: ScreenUtil.getWidth(context) / 1,
              height: ScreenUtil.getHeight(context) / 3,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                child: GoogleMap(
                  mapType: MapType.normal,
                  zoomControlsEnabled: false,
                  gestureRecognizers: Set()
                    ..add(Factory<EagerGestureRecognizer>(
                        () => EagerGestureRecognizer())),
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                    onmapcreated();
                  },
                  markers: markers,
                  myLocationButtonEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(widget.latitude, widget.longitude),
                    zoom: 15.0,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: ExpansionTile(
                  title: Text(
                    "Adres Tarifi",
                    style: TextStyle(
                      color: TextColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  iconColor: TextColor,
                  collapsedIconColor: TextColor,
                  backgroundColor: BGColor1,
                  collapsedBackgroundColor: BGColor1,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.all(20),
                      child: Text(
                        widget.adresDetail +
                            "\nBina no: " +
                            widget.userCallsItem.apt +
                            " kat " +
                            widget.userCallsItem.kat +
                            " daire no:" +
                            widget.userCallsItem.no +
                            "\nAdres Tarifi: " +
                            widget.userCallsItem.adres,
                        style: TextStyle(
                          color: TextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: BGColor1,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Değerlendirmem",
                    style: TextStyle(
                      color: TextColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  widget.myRate == null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                  color: buttonColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: TextButton(
                                onPressed: () {
                                  RateModel rateModel = new RateModel();
                                  rateModel.CallId = widget.userCallsItem.Id;
                                  rateModel.ServiceId =
                                      widget.userCallsItem.ServiceId;
                                  rateModel.UserId =
                                      widget.userCallsItem.UserId;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RatingPage(rateModel)));
                                },
                                child: Text(
                                  "Değerlendir",
                                  style:
                                      TextStyle(fontSize: 20, color: TextColor),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(buttonColor),
                                ),
                              ),
                            )
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: ScreenUtil.getWidth(context) / 1.8,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.myRate!.Comment,
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
                            Container(
                                height: ScreenUtil.getHeight(context) / 15,
                                width: ScreenUtil.getWidth(context) / 9,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Functions().ColorDetecter(
                                        widget.myRate!.RateCount.toDouble())),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Puan",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                      Text(
                                        widget.myRate!.RateCount.toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void yenile() {
    setState(() {});
  }

  void getAdress() async {
    if (widget.adresDetail == "") {
      final coordinates =
          new Coordinates(widget.userCallsItem.lat, widget.userCallsItem.lon);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);

      widget.adresDetail = addresses.first.addressLine;
      setState(() {});
    }
  }

  Future<void> getMyRate() async {
    try {
      if (widget.durum == true) {
        var veriler = await _firestore
            .collection("Ratings")
            .where("CallId", isEqualTo: widget.userCallsItem.Id)
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
          widget.myRate = rateModel;
          print("asdsadsa" + rateModel.RateCount.toString());
          setState(() {
            widget.durum = false;
          });
        }
      }
    } catch (e) {
      WarningWidget(e.toString() + " Hatası alındı", "Hata", context);
    }
  }
}

class util {
  static String DarkmapStyle = '''

[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#1d2c4d"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#8ec3b9"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1a3646"
      }
    ]
  },
  {
    "featureType": "administrative.country",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#4b6878"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#64779e"
      }
    ]
  },
  {
    "featureType": "administrative.province",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#4b6878"
      }
    ]
  },
  {
    "featureType": "landscape.man_made",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#334e87"
      }
    ]
  },
  {
    "featureType": "landscape.natural",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#023e58"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#283d6a"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#6f9ba5"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1d2c4d"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#023e58"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#3C7680"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#304a7d"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#98a5be"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1d2c4d"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#2c6675"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#255763"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#b0d5ce"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#023e58"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#98a5be"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1d2c4d"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#283d6a"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#3a4762"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#0e1626"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#4e6d70"
      }
    ]
  }
]
  ''';

  static String LightmapStyle = '''[]''';
}
