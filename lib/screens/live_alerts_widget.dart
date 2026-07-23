import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class LiveAlertsWidget extends StatelessWidget {
  final String classId;

  const LiveAlertsWidget({super.key, required this.classId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('class_alerts')
          .doc(classId)
          .collection('alerts')
          .orderBy('timestamp', descending: true)
          .snapshots(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _emptyState();
        }

        final alerts = snapshot.data!.docs;

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: alerts.length,
          itemBuilder: (context, index) {
            final data = alerts[index].data() as Map<String, dynamic>;
            return _alertCard(data);
          },
        );
      },
    );
  }

  // 🔴 ALERT CARD
  Widget _alertCard(Map<String, dynamic> data) {
    final time = data['timestamp'] != null
        ? DateFormat('hh:mm a')
            .format(data['timestamp'].toDate())
        : '';

    Color color;
    IconData icon;

    switch (data['type']) {
      case "MODE_TURNED_OFF":
        color = Colors.deepOrange;
        icon = Icons.warning;
        break;
      case "SCREEN_UNLOCKED":
        color = Colors.orange;
        icon = Icons.screen_lock_portrait;
        break;
      default:
        color = Colors.red;
        icon = Icons.phone_android;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: color, width: 5)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['studentName'] ?? "Unknown Student",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  data['message'] ?? "",
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),

          Text(
            time,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  // 💤 EMPTY STATE
  Widget _emptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 80),
          SizedBox(height: 12),
          Text(
            "No alerts",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "All students are disciplined 😌",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}