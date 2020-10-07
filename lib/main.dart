import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'landing.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
          return Container();
        } else if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'SafeEntry for GraSPP',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: LandingPage(),
            builder: (BuildContext context, Widget child) {
              /// make sure that loading can be displayed in front of all other widgets
              return FlutterEasyLoading(child: child);
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}