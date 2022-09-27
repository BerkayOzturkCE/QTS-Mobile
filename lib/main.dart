import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technical_services/User/Pages/DateSelector/DateSelector.dart';
import 'package:technical_services/User/Pages/Map/maps.dart';
import 'package:technical_services/User/Pages/Profile/ProfilePage.dart';
import 'package:technical_services/User/Pages/Signup/signup.dart';
import 'package:technical_services/User/Utils/functions.dart';
import 'package:technical_services/User/data/data.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('tr', null).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/DateSelector': (context) => DateSelectorPage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: App(),
    );
  }
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Hata();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return LoginPage();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Wait();
      },
    );
  }
}

class Hata extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          "Bağlantı hatası",
          style: TextStyle(
            fontSize: 28,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class Wait extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
