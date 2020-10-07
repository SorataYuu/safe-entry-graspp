import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'first_screen.dart';
import 'login_page.dart';


class LoadingPage extends StatelessWidget {

  final Future<User> _initialAuth = FirebaseAuth.instance.authStateChanges().first;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialAuth,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot == null) {
          return LoadingPage();
        } else if (snapshot.connectionState == ConnectionState.done) {
          return FirstScreen();
        } else {
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
}