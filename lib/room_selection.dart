import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'login.dart';
import "rooms.dart";
import 'check_in.dart';
import 'checked_in.dart';
import 'auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RoomSelection extends StatefulWidget {
  @override
  _RoomSelectionState createState() => _RoomSelectionState();
}

class _RoomSelectionState extends State<RoomSelection> {

  User currentUser = _auth.currentUser;

  @override
  void initState() {
    super.initState();
    _listen();
  }
  void _listen() {
    checkIfUserIsCheckedIn(currentUser.uid).then((checkedIn) {
      if (checkedIn) {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => CheckedInPage()
        )
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('GSC_Logo.png'),
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
          IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Sign Out',
              onPressed: () async {
                final auth = Provider.of<Auth>(context, listen: false);
                await auth.signOut();
                await Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) {
                      return LoginPage();
                    }), ModalRoute.withName('/'));
              }
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
        child: StreamBuilder<QuerySnapshot>(
            stream: getCheckInForUser(currentUser.uid),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                  return ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: roomList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return StreamBuilder<QuerySnapshot>(
                        stream: getCheckInForRoom(roomList[index].id),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container();
                          }

                          return Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        roomList[index].imageUrl),
                                  ),
                                  title: Text(roomList[index].name),
                                  subtitle: Text('Max Capacity: ' +
                                      roomList[index].capacity.toString()),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Chip(
                                      backgroundColor: Colors.red,
                                      label: Text('Space Left: ' +
                                          (roomList[index].capacity -
                                              snapshot.data.size).toString(),
                                          style: TextStyle(color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    const SizedBox(width: 8),
                                    RaisedButton(
                                      color: Colors.blueAccent,
                                      child: const Text('Check In Here',
                                        style: TextStyle(color: Colors.white),),
                                      onPressed: () async {
                                        await checkIntoRoom(
                                            currentUser.uid,
                                            roomList[index].id);
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    CheckedInPage()));
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context,
                        int index) => const Divider(),
                  );
                }
              }
        ),
      ),
    );
  }
}