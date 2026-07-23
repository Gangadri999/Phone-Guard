import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiveAlertsPage extends StatelessWidget {
  final String classId;

  const LiveAlertsPage({super.key, required this.classId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🚨 Live Alerts"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('alerts')
            .where('classId', isEqualTo: classId)
            .orderBy('timestamp', descending: true)
            .limit(20) // ⚡ fast
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final alerts = snapshot.data!.docs;

          if (alerts.isEmpty) {
            return const Center(child: Text("No alerts"));
          }

          return ListView.builder(
            itemCount: alerts.length,
            itemBuilder: (context, index) {
              final data = alerts[index];

              return Card(
                color: Colors.red.shade100,
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: const Icon(Icons.warning, color: Colors.red),
                  title: Text(
                    "${data['studentName']} → ${data['message']}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(data['classId']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}