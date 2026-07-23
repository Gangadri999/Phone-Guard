import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Save user profile after signup
  Future<void> saveUserProfile({
    required String uid,
    required String email,
    required String role, // teacher / student
  }) async {
    await _db.collection('users').doc(uid).set({
      'email': email,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Get user role safely
  Future<String> getUserRole(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();

    if (!doc.exists) {
      return 'student'; // default role (SAFE)
    }

    return doc.data()?['role'] ?? 'student';
  }
}
