import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:technical_services/User/Pages/Chat/chat.dart';
import 'package:technical_services/User/Pages/DateSelector/DateSelector.dart';
import 'package:technical_services/User/Utils/functions.dart';
import 'package:technical_services/User/Widgets/widgets.dart';
import 'package:technical_services/User/data/UserCalls.dart';
import 'package:technical_services/User/data/data.dart';

class MyMap extends StatefulWidget {
  double latitude = 39.9030394, longitude = 32.4825798;
  bool status = false;
  MyMap();

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  late GoogleMapController _controller;
  Set<Marker> markers = {};
  TextEditingController katcontroller = TextEditingController();
  TextEditingController aptcontroller = TextEditingController();
  TextEditingController adrescontroller = TextEditingController();
  TextEditingController nocontroller = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _getCurrentLocation() async {
    if (widget.status == false) {
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
      if (mounted) {
        setState(() {
          widget.latitude = knm.latitude;

          widget.longitude = knm.longitude;

          _controller.animateCamera(
            CameraUpdate.newLatLng(LatLng(widget.latitude, widget.longitude)),
          );
          onmapcreated();

          widget.status = true;
        });
      }
    }
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
    _getCurrentLocation();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 25,
        elevation: 0,
        actions: [],
        title: Text(
          "Servis Çağır",
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
              margin: EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: ScreenUtil.getWidth(context) / 3.5,
                  child: TextField(
                    controller: aptcontroller,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: "Bina No",
                      hintStyle: TextStyle(
                        fontSize: 14,
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
                Container(
                  width: ScreenUtil.getWidth(context) / 3.5,
                  child: TextField(
                    controller: katcontroller,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: "Kat",
                      hintStyle: TextStyle(
                        fontSize: 14,
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
                Container(
                  width: ScreenUtil.getWidth(context) / 3.5,
                  child: TextField(
                    controller: nocontroller,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: "Daire No",
                      hintStyle: TextStyle(
                        fontSize: 14,
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
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextField(
                maxLines: 5,
                controller: adrescontroller,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  /*suffixIcon:
                          IconButton(onPressed: () {}, icon: Icon(Icons.visibility_off),padding: EdgeInsets.all(),),*/
                  hintText: "Adres Açıklaması",
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
            GestureDetector(
              onTap: () {
                complete = false;
                ServisEkle(context);
              },
              child: Container(
                margin: EdgeInsets.only(left: 100, right: 100, top: 20),
                width: ScreenUtil.getWidth(context),
                height: 60,
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Icon(
                        FontAwesomeIcons.calendarPlus,
                        color: TextColor,
                        size: 30,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Text(
                        "Tarih Seç",
                        style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 1,
                          color: TextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void ServisEkle(BuildContext context) {
    if (adrescontroller.text != "" &&
        aptcontroller.text != "" &&
        katcontroller.text != "" &&
        nocontroller.text != "") {
      userCalls.adres = adrescontroller.text;
      userCalls.apt = aptcontroller.text;
      userCalls.kat = katcontroller.text;
      userCalls.no = nocontroller.text;
      userCalls.lat = widget.latitude;
      userCalls.lon = widget.longitude;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => DateSelectorPage()));
    } else {
      WarningWidget("Lütfen boş yerleri doldurun", "Hata", context);
    }
  }

  @override
  void yenile() {
    setState(() {});
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
