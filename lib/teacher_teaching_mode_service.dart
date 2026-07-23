import 'package:cloud_firestore/cloud_firestore.dart';

class TeachingModeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> setTeachingMode({
    required String classId,
    required bool enabled,
  }) async {
    // 1️⃣ Update class session
    await _firestore.collection('class_sessions').doc(classId).set({
      'teachingMode': enabled,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // 2️⃣ Get all students in class
    final studentsSnap = await _firestore
        .collection('class_students')
        .doc(classId)
        .collection('students')
        .get();

    // 3️⃣ Update every student
    for (var doc in studentsSnap.docs) {
      await _firestore
          .collection('students')
          .doc(doc.id)
          .update({'teachingMode': enabled});
    }
  }
}