import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // kIsWeb

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ================= EMAIL LOGIN =================
  Future<User?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  // ================= EMAIL REGISTER =================
  Future<User?> registerWithEmail({
    required String email,
    required String password,
    required Map<String, dynamic> userData,
  }) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = result.user!;
    final role = userData['role'];

    // users (common)
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': email,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // role-based collection
    if (role == 'student') {
      await _firestore.collection('students').doc(user.uid).set({
        ...userData,
        'uid': user.uid,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else if (role == 'teacher') {
      await _firestore.collection('teachers').doc(user.uid).set({
        ...userData,
        'uid': user.uid,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return user;
  }

  // ================= GOOGLE SIGN-IN (WEB ONLY – FIXED) =================
  Future<User?> signInWithGoogle() async {
    if (!kIsWeb) {
      throw Exception(
        "Google Sign-In is only enabled for Web in this build",
      );
    }

    final GoogleAuthProvider provider = GoogleAuthProvider();
    provider.addScope('email');
    provider.addScope('profile');

    final UserCredential credential =
        await _auth.signInWithPopup(provider);

    return credential.user;
  }

  // ================= SAVE GOOGLE USER ROLE =================
  Future<void> saveGoogleUserRole({
    required User user,
    required String role,
  }) async {
    final uid = user.uid;

    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'email': user.email,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (role == 'student') {
      await _firestore.collection('students').doc(uid).set({
        'uid': uid,
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } else if (role == 'teacher') {
      await _firestore.collection('teachers').doc(uid).set({
        'uid': uid,
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  // ================= GET USER ROLE =================
  Future<String?> getUserRole(String uid) async {
    final doc =
        await _firestore.collection('users').doc(uid).get();

    if (!doc.exists) return null;
    return doc.data()?['role'] as String?;
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    await _auth.signOut();
  }
}