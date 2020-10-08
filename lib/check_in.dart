import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<void> checkIntoRoom(userID, roomID) async {
  await Firebase.initializeApp();

  CollectionReference checkins = firestore.collection('checkins');

  return checkins
      .add({
        'userID': userID, // John Doe
        'roomID': roomID, // Stokes and Sons
        'timestamp': DateTime.now().millisecondsSinceEpoch // 42
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