import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  FirebaseService();

  Stream<QuerySnapshot<Map<String, dynamic>>> fireBaseUserChange() {
    return FirebaseFirestore.instance
        .collection('day-plan')
        .where('uID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchInit() async {
    final snapShot = await FirebaseFirestore.instance
        .collection('day-plan')
        .where('uID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    return snapShot;
  }
}
