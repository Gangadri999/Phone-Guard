import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentTeachingModeListener {
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  void listen(Function(bool enabled) onChange) {
    FirebaseFirestore.instance
        .collection('students')
        .doc(_uid)
        .snapshots()
        .listen((doc) {
      if (!doc.exists) return;

      final enabled = doc['teachingMode'] ?? false;
      onChange(enabled);
    });
  }
}