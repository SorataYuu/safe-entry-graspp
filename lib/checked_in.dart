import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:safeentry/room_selection.dart';

import 'login.dart';
import 'google_sign_in.dart';
import "rooms.dart";
import 'check_in.dart';
import 'auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class CheckedInPage extends StatefulWidget {
  @override
  _CheckedInPageState createState() => _CheckedInPageState();
}

class _CheckedInPageState extends State<CheckedInPage> {

  User currentUser = _auth.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/GSC_Logo.png'),
            ),
            const SizedBox(width: 8),
            Text(
              "Safe Entry",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.normal),
            )
          ]
        ),
        actions: <Widget>[
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
        child: Center(
          child: StreamBuilder<QuerySnapshot>(
            stream: getCheckInForUser(currentUser.uid),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

              int roomID;
              DateTime timestamp;
              var snapshotData;
              var snapshotID;

              if (snapshot.hasError) {
                return Center(
                  child: Chip(
                    backgroundColor: Colors.red,
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.refresh_rounded, size: 20),
                        Text("Please refresh", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                      ]
                    ),
                  )
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }

              if (snapshot.connectionState == ConnectionState.active && snapshot.hasData && snapshot.data.size > 0) {
                snapshotData = snapshot.data.docs[0].data();
                snapshotID = snapshot.data.docs[0].id;
                roomID = snapshotData["roomID"];
                timestamp = DateTime.fromMillisecondsSinceEpoch(snapshotData["timestamp"]);

                return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle_rounded, size: 30, color: Colors.green),
                                    Text(
                                      "Checked In",
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.green,
                                          fontWeight: FontWeight.normal),
                                    )
                                  ]
                              )
                          ),
                          Chip(
                            backgroundColor: Colors.green,
                            label: Text(DateFormat.yMMMEd().add_jm().format(timestamp), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 20),
                          CircleAvatar(
                            backgroundImage: AssetImage(roomList[roomID].imageUrl),
                            radius: 60,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            roomList[roomID].name,
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(height: 8),
                          StreamBuilder<QuerySnapshot>(
                            stream: getCheckInForRoom(roomList[roomID].id),
                            builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshotNew) {
                            if (snapshotNew.hasError) {
                              return Container();
                            }

                            if (snapshotNew.connectionState ==
                            ConnectionState.waiting) {
                              return Container();
                            }

                            return Chip(
                              backgroundColor: Colors.blue,
                              label: Text('Capacity: '+ snapshotNew.data.size.toString() + ' / ' + roomList[roomID].capacity.toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            );
                          },
                        ),
                          const SizedBox(height: 8),
                          RaisedButton(
                            color: Colors.blueAccent,
                            child: const Text('Check Out', style: TextStyle(color: Colors.white),),
                            onPressed: () async {
                              checkOut(snapshotData, snapshotID);
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    )
                );
              } else {
                return Container();
              }
            },
          )
        )
      ),
    );
  }
}