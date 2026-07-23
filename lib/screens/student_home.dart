import 'package:flutter/material.dart';
import 'phone_misuse_service.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({Key? key}) : super(key: key);

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  final PhoneMisuseService _service = PhoneMisuseService();

  @override
  void initState() {
    super.initState();
    _service.start();
  }

  @override
  void dispose() {
    _service.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Monitoring")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.warning, size: 80),
            SizedBox(height: 16),
            Text(
              "Phone misuse monitoring active",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
