import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/login_page.dart';
import '../screens/role_selection_page.dart';
import '../screens/student_dashboard.dart';
import '../screens/teacher_dashboard.dart';

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnap) {
        if (authSnap.connectionState == ConnectionState.waiting) {
          return const _Loading();
        }

        if (!authSnap.hasData) {
          return  LoginPage();
        }

        final uid = authSnap.data!.uid;

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .get(),
          builder: (context, roleSnap) {
            if (roleSnap.connectionState == ConnectionState.waiting) {
              return const _Loading();
            }

            if (!roleSnap.hasData || !roleSnap.data!.exists) {
              return  RoleSelectionPage();
            }

            final data = roleSnap.data!.data() as Map<String, dynamic>;
            final role = data['role'];

            if (role == 'student') {
              return  StudentDashboard();
            }

            if (role == 'teacher') {
              return  TeacherDashboard();
            }

            return  RoleSelectionPage();
          },
        );
      },
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}