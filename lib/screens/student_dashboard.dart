import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class StudentDashboard extends StatefulWidget {
  final String studentId;
  final String classId;

  const StudentDashboard({
    super.key,
    required this.studentId,
    required this.classId,
  });

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard>
    with WidgetsBindingObserver {

  bool teachingMode = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    /// 🔥 Listen Teacher Control
    FirebaseFirestore.instance
        .collection('class_controls')
        .doc(widget.classId)
        .snapshots()
        .listen((doc) async {

      if (doc.exists) {
        bool mode = doc['teachingMode'] ?? false;

        setState(() {
          teachingMode = mode;
        });

        /// 🔥 Update student status (IMPORTANT)
        await FirebaseFirestore.instance
            .collection('students')
            .doc(widget.studentId)
            .update({
          'teachingMode': mode,
          'online': true,
        });
      }
    });
  }

  /// 🚨 App minimize detection
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && teachingMode) {
      sendAlert("App minimized");
    }
  }

  /// 🚨 Send Alert (FIXED)
  Future<void> sendAlert(String message) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('students')
          .doc(widget.studentId)
          .get();

      final name = doc.exists ? doc['name'] ?? "Unknown" : "Unknown";

      await FirebaseFirestore.instance.collection('alerts').add({
        'studentId': widget.studentId,
        'studentName': name,
        'classId': widget.classId,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print("✅ Alert sent");
    } catch (e) {
      print("❌ Alert error: $e");
    }
  }

  /// 🚨 Manual OFF (FIXED)
  Future<void> manualOff() async {
    await sendAlert("Manual OFF (Cheating)");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("🚨 Teacher notified")),
    );
  }

  /// 🔒 Back button block
  Future<bool> _onWillPop() async {
    if (teachingMode) {
      sendAlert("Back button pressed");
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    /// 🔒 Full screen lock
    if (teachingMode) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor:
            teachingMode ? Colors.red.shade200 : Colors.green.shade200,

        appBar: AppBar(
          title: const Text("Student Dashboard"),
          automaticallyImplyLeading: false,
        ),

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                teachingMode
                    ? "🔒 LOCKED BY TEACHER"
                    : "✅ NORMAL MODE",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              if (teachingMode)
                ElevatedButton(
                  onPressed: manualOff,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text("Turn OFF (Cheat)"),
                ),

              const SizedBox(height: 20),

              const Text(
                "If you leave app or cheat,\nTeacher will be alerted 🚨",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}