import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentListPage extends StatelessWidget {
  final String classId;

  const StudentListPage({super.key, required this.classId});

  @override
  Widget build(BuildContext context) {

    final parts = classId.split("_");

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        title: const Text("👨‍🎓 Students"),
        backgroundColor: Colors.transparent,
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('students')
            .where('department', isEqualTo: parts[0])
            .where('year', isEqualTo: parts[1])
            .where('section', isEqualTo: parts[2])
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text("No Students Found",
                  style: TextStyle(color: Colors.white)),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {

              final d = docs[i];
              final data = d.data() as Map<String, dynamic>;

              final name = data['name'] ?? "Unknown";
              final online = data['online'] ?? false;
              final locked = data['teachingMode'] ?? false;

              final mismatch = online && !locked;

              /// 🔥 AUTO ALERT
              if (mismatch && data['alertSent'] != true) {
                FirebaseFirestore.instance.collection('alerts').add({
                  'name': name,
                  'classId': classId,
                  'message': "Cheating Detected 🚨",
                  'time': Timestamp.now(),
                });

                FirebaseFirestore.instance
                    .collection('students')
                    .doc(d.id)
                    .update({'alertSent': true});
              }

              return AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                decoration: BoxDecoration(
                  color: mismatch
                      ? Colors.red.withOpacity(0.2)
                      : Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: ListTile(
                  title: Text(name,
                      style: const TextStyle(color: Colors.white)),

                  subtitle: Text(
                    online ? "Online" : "Offline",
                    style: TextStyle(
                        color: online ? Colors.green : Colors.grey),
                  ),

                  trailing: Icon(
                    locked ? Icons.lock : Icons.lock_open,
                    color: locked ? Colors.red : Colors.green,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}