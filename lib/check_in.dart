import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

CollectionReference checkins = firestore.collection('checkins');
CollectionReference history = firestore.collection('history');

Future<void> checkIntoRoom(userID, roomID) async {
  await Firebase.initializeApp();

  return checkins
      .add({
        'userID': userID,
        'roomID': roomID,
        'timestamp': DateTime.now().millisecondsSinceEpoch
      });
}


Future<void> checkOut(snapshot, id) async  {
  history
  .add({
    'userID': snapshot["userID"],
    'roomID': snapshot["roomID"],
    'checkInTimestamp': snapshot["timestamp"],
    'checkOutTimestamp': DateTime.now().millisecondsSinceEpoch
  })
  .then((value) {
    return checkins
        .doc(id)
        .delete()
        .then((value) => print("Checked Out"))
        .catchError((error) => print("Failed to delete checkin: $error"));
  });
}

Stream getCheckIns() {
  return firestore.collection('checkins').snapshots(includeMetadataChanges: true);
}

Stream getCheckInForRoom(int roomID) {
  return firestore
      .collection('checkins')
      .where('roomID', isEqualTo: roomID)
      .snapshots(includeMetadataChanges: true);
}

Future<bool> checkIfUserIsCheckedIn(String userID) async {
  var completer = new Completer<bool>();

  firestore
      .collection('checkins')
      .where('userID', isEqualTo: userID)
      .get()
      .then((QuerySnapshot querySnapshot) => {
        completer.complete(querySnapshot.size != 0)
      });

  return completer.future;
}

Stream getCheckInForUser(String userID) {
  return firestore
      .collection('checkins')
      .where('userID', isEqualTo: userID)
      .snapshots(includeMetadataChanges: true);
}