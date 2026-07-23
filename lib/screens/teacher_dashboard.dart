import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'student_list_page.dart';
import 'live_alerts_page.dart';
import 'analytics_page.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard>
    with SingleTickerProviderStateMixin {

  /// 🎯 CLASS SELECTION
  String dept = "CSE";
  String year = "3";
  String section = "A";

  /// 🔒 TEACHING MODE
  bool teachingMode = false;

  /// 🎬 ANIMATION
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  /// 📌 CLASS ID
  String get classId => "${dept}_${year}_$section";

  @override
  void initState() {
    super.initState();

    /// Animation init
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    /// Listen current teaching mode
    _listenTeachingMode();
  }

  void _listenTeachingMode() {
    FirebaseFirestore.instance
        .collection('class_controls')
        .doc(classId)
        .snapshots()
        .listen((snapshot) {

      if (!snapshot.exists) return;

      final data = snapshot.data() as Map<String, dynamic>;

      setState(() {
        teachingMode = data['teachingMode'] ?? false;
      });
    });
  }

  /// 🔥 UPDATE TEACHING MODE
  void _updateTeachingMode(bool value) async {
    setState(() => teachingMode = value);

    await FirebaseFirestore.instance
        .collection('class_controls')
        .doc(classId)
        .set({
      'teachingMode': value,
    });
  }

  /// 🎨 NAV BUTTON UI
  Widget _navButton(String title, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(18),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🎨 DROPDOWN UI
  Widget _dropdown(String value, List<String> items, Function(String?) onChanged) {
    return Expanded(
      child: DropdownButtonFormField(
        value: value,
        dropdownColor: const Color(0xFF1E293B),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF1E293B),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        items: items
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        title: const Text("🎓 Teacher Control Center"),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),

      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔽 CLASS SELECTION
              const Text(
                "CLASS SELECTION",
                style: TextStyle(
                  color: Colors.white54,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  _dropdown(dept, ["CSE","ECE","EEE","IT"], (v) {
                    setState(() => dept = v!);
                  }),
                  const SizedBox(width: 10),
                  _dropdown(year, ["1","2","3","4"], (v) {
                    setState(() => year = v!);
                  }),
                  const SizedBox(width: 10),
                  _dropdown(section, ["A","B","C","D"], (v) {
                    setState(() => section = v!);
                  }),
                ],
              ),

              const SizedBox(height: 30),

              /// 🚀 NAVIGATION BUTTONS
              Row(
                children: [

                  _navButton("👨‍🎓 Students", Colors.blue, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StudentListPage(classId: classId),
                      ),
                    );
                  }),

                  _navButton("🚨 Alerts", Colors.orange, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LiveAlertsPage(classId: classId),
                      ),
                    );
                  }),

                  _navButton("📊 Analytics", Colors.purple, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AnalyticsPage(classId: classId),
                      ),
                    );
                  }),
                ],
              ),

              const SizedBox(height: 40),

              /// 🔒 TEACHING MODE CARD
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: teachingMode
                      ? Colors.red.withOpacity(0.2)
                      : Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text(
                          "TEACHING MODE",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          teachingMode ? "ACTIVE 🔒" : "DISABLED ✅",
                          style: TextStyle(
                            color: teachingMode
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                      ],
                    ),

                    Switch(
                      value: teachingMode,
                      onChanged: _updateTeachingMode,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// 📊 LIVE STATUS (ANALYTICS PREVIEW)
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('students')
                    .where('department', isEqualTo: dept)
                    .where('year', isEqualTo: year)
                    .where('section', isEqualTo: section)
                    .snapshots(),

                builder: (context, snapshot) {

                  if (!snapshot.hasData) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  int total = docs.length;
                  int online = docs.where((d) => d['online'] == true).length;
                  int locked = docs.where((d) => d['teachingMode'] == true).length;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text("LIVE STATUS",
                          style: TextStyle(color: Colors.white54)),

                      const SizedBox(height: 10),

                      Text("Total Students: $total",
                          style: const TextStyle(color: Colors.white)),

                      Text("Online: $online",
                          style: const TextStyle(color: Colors.green)),

                      Text("Locked: $locked",
                          style: const TextStyle(color: Colors.red)),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}