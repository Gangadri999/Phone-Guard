import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/auth_service.dart';
import 'teacher_dashboard.dart';
import 'student_dashboard.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return FutureBuilder(
      future: auth.getUserRole(uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.data == 'teacher') {
          return TeacherDashboard();
        } else {
          return StudentDashboard();
        }
      },
    );
  }
}
