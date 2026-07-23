import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiveStudentList extends StatelessWidget {
  final String classId;

  const LiveStudentList({super.key, required this.classId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('class_students')
          .doc(classId)
          .collection('students')
          .snapshots(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _empty();
        }

        final students = snapshot.data!.docs;

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: students.length,
          itemBuilder: (context, index) {
            final data = students[index].data() as Map<String, dynamic>;
            return _studentCard(data);
          },
        );
      },
    );
  }

  // 🎓 STUDENT CARD
  Widget _studentCard(Map<String, dynamic> data) {
    final bool online = data['online'] ?? false;
    final bool teachingMode = data['teachingMode'] ?? false;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black12,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          // ONLINE INDICATOR
          CircleAvatar(
            radius: 6,
            backgroundColor: online ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 12),

          // NAME & ROLL
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['name'] ?? 'Unknown',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  data['rollNo'] ?? '',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          // TEACHING MODE STATUS
          Icon(
            teachingMode ? Icons.lock : Icons.lock_open,
            color: teachingMode ? Colors.red : Colors.green,
          ),
        ],
      ),
    );
  }

  // EMPTY UI
  Widget _empty() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group_off, size: 80, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            "No students found",
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}