import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login.dart';
import 'google_sign_in.dart';
import "rooms.dart";
import 'check_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class FirstScreen extends StatelessWidget {

  final User currentUser = _auth.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SafeEntry for GraSPP'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () {
              signOutGoogle();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {return LoginPage();}), ModalRoute.withName('/'));
            },
          ),
          Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Center(
                child: Text(
                  currentUser.displayName,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.normal),
                )
              )
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                currentUser.photoURL,
              ),
              radius: 20,
              backgroundColor: Colors.transparent,
            ),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue[100], Colors.blue[400]],
          ),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: roomList.length,
          itemBuilder: (BuildContext context, int index) {
            return StreamBuilder<QuerySnapshot>(
              stream: getCheckInForRoom(roomList[index].id),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return RaisedButton(
                onPressed: () {
                  print(snapshot.data.size);
                  //checkIntoRoom(currentUser.uid, roomList[index].id);
                },
                color: Colors.blue,
                child: Row(
                  children: [
                    Icon(
                      Icons.auto_stories,
                      color: Colors.white,
                      size: 24.0
                    ),
                    Expanded(
                      child: Text(
                        roomList[index].name,
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      )
                    ),
                    Chip(
                      backgroundColor: Colors.red,
                      label: Text((roomList[index].capacity - snapshot.data.size).toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    )
                  ]
                ),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
              );
            },
          );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
        ),
      ),
    );
  }
}