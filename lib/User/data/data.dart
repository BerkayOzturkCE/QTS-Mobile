import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:technical_services/User/data/Services.dart';
import 'package:technical_services/User/data/User.dart';

import 'UserCalls.dart';
import 'message.dart';

UserCalls userCalls = new UserCalls();
late UserData CurrentuserData;
bool complete = false;
List<Message> GenmessageList = [];
List<UserCalls> callsList = [];
late Services Activeservices;
late User activeUser;
String ThemeType = "";
Color ScaffoldColor = Color.fromARGB(255, 47, 49, 54); //Scaffold color
Color? buttonColor = Color.fromARGB(255, 62, 66, 73); //Button color
Color? buttonColor2 = Color.fromARGB(255, 62, 66, 73); //Button color

Color AppbarColor = Color.fromARGB(255, 32, 34, 37); //Appbar color
Color TextColor = Colors.white; //Text color
Color? TextDateColor = Colors.grey; //Text color

Color TextenterColor = Colors.white; //Text color

Color? TextfieldColor = Colors.white; //Text color

Color? BGColor1 = Color.fromARGB(255, 54, 57, 63); //Background color layout 1
Color BGColor2 = Color.fromARGB(255, 54, 57, 63); //Background color layout 2
Color BGColor3 = Color.fromARGB(255, 62, 66, 73); //Background color layout 3
Color BGColor4 = Color.fromARGB(255, 62, 66, 73); //Background color layout 3

Color CircularLoadingIndicatorColor =
    Colors.grey; //Circular loading indicator layout
Color dividerColor = Colors.grey; //Divider color

class Theme_data {
  DarkThemeData() {
    ThemeType = "Dark";
    buttonColor = Color.fromARGB(255, 62, 66, 73); //Button color
    buttonColor2 = BGColor1 = Color.fromARGB(255, 54, 57, 63); //Button color

    AppbarColor = Color.fromARGB(255, 32, 34, 37); //Appbar color
    ScaffoldColor = Color.fromARGB(255, 47, 49, 54); //Scaffold color
    TextColor = Colors.white; //Text color
    TextfieldColor = Colors.white; //Text color
    TextenterColor = Colors.black;
    BGColor1 = Color.fromARGB(255, 54, 57, 63); //Background color layout 1
    BGColor2 = Color.fromARGB(255, 54, 57, 63); //Background color layout 2
    BGColor3 = Color.fromARGB(255, 62, 66, 73); //Background color layout 3

    CircularLoadingIndicatorColor =
        Colors.grey; //Circular loading indicator layout
    dividerColor = Colors.grey; //Divider color
  }

  LightThemeData() {
    ThemeType = "Light";
    buttonColor = Color.fromARGB(255, 95, 169, 188); //Button color
    buttonColor2 = Color.fromARGB(255, 154, 206, 222);
    AppbarColor = Color.fromARGB(255, 204, 225, 240); //Appbar color
    ScaffoldColor = Color.fromARGB(255, 204, 225, 240); //Scaffold color
    TextColor = Colors.black; //Text color
    TextenterColor = Colors.black;

    BGColor1 = Color.fromARGB(255, 154, 206, 222); //Background color layout 1
    BGColor2 = Color.fromARGB(255, 95, 169, 188); //Background color layout 2
    BGColor3 = Color.fromARGB(255, 95, 169, 188); //Background color layout 3

    CircularLoadingIndicatorColor =
        Colors.grey; //Circular loading indicator layout
    dividerColor = Colors.grey; //Divider color
    TextfieldColor = Color.fromARGB(255, 154, 206, 222); //Text color
    return 0;
  }
}

class ScreenUtil {
  static getSize(context) {
    return MediaQuery.of(context).size;
  }

  static getWidth(context) {
    return MediaQuery.of(context).size.width;
  }

  static getHeight(context) {
    return MediaQuery.of(context).size.height;
  }

  static minimumSize(context) {
    double enkucuk = getWidth(context);
    if (getWidth(context) > getHeight(context)) {
      enkucuk = getHeight(context);
    }
    return enkucuk;
  }

  static divideWidth(context, {divided = 1}) {
    return MediaQuery.of(context).size.width / divided;
  }
}
