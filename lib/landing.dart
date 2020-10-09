import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth.dart';
import 'login.dart';
import 'room_selection.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = new Duration(seconds: 2);
    return new Timer(duration, route);
  }

  route() {
    final _user = FirebaseAuth.instance.currentUser;

    if(_user != null){
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => RoomSelection()
      )
      );
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => LoginPage()
      )
      );
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('GSC_Logo.png', width: 150),
                Text(
                  "Safe Entry for GraSPP",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 50),
                CircularProgressIndicator(),
              ],
            ),
          )
      ),
    );
  }
}