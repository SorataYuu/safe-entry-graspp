import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'login_page.dart';
import 'first_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

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
            home: LoginPage(),
          );
        } else {
          return Container();

          return Scaffold(
            body: Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlutterLogo(size: 150),
                    CircularProgressIndicator()
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}