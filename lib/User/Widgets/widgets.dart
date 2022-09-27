// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:technical_services/User/data/data.dart';

Future WarningWidget(String warning, String title, BuildContext context) async {
  showDialog(
    useRootNavigator: true,
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(const Radius.circular(15))),
        backgroundColor: BGColor1,
        title: Text(
          title,
          style: TextStyle(color: TextColor),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(
                warning,
                style: TextStyle(color: TextColor),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                  buttonColor,
                )),
                child: Text(
                  'Tamam',
                  style: TextStyle(color: TextColor),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          )
        ],
      );
    },
  );
}

Future WarningWidgetWait(
    String warning, String title, BuildContext context, String route) async {
  showDialog(
    useRootNavigator: true,
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(const Radius.circular(15))),
        backgroundColor: BGColor1,
        title: Text(
          title,
          style: TextStyle(color: TextColor),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(
                warning,
                style: TextStyle(color: TextColor),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                  buttonColor,
                )),
                child: Text(
                  'Tamam',
                  style: TextStyle(color: TextColor),
                ),
                onPressed: () {
                  Navigator.of(context).popUntil(ModalRoute.withName(route));
                },
              ),
            ],
          )
        ],
      );
    },
  );
}

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<bool?> ToastWidget(String message) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.grey[600],
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
