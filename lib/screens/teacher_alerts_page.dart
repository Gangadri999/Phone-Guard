import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TeacherAlertsPage extends StatelessWidget {
  final String classId;

  const TeacherAlertsPage({super.key, required this.classId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), 
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "SECURITY FEED",
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Positioned(top: -100, right: -50, child: _orb(300, Colors.red.withOpacity(0.1))),
          SafeArea(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('live_alerts')
                  .where('classId', isEqualTo: classId)
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return const Center(child: Text("Error", style: TextStyle(color: Colors.white)));
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.redAccent));
                }

                final alerts = snapshot.data!.docs;
                if (alerts.isEmpty) return _emptyState();

                return Column(
                  children: [
                    _buildHeaderStats(alerts.length),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: alerts.length,
                        itemBuilder: (context, index) => _alertCard(alerts[index]),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _orb(double size, Color color) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70), child: Container(color: Colors.transparent)),
    );
  }

  Widget _buildHeaderStats(int count) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.circle, color: Colors.redAccent, size: 8),
                const SizedBox(width: 8),
                Text("LIVE: $count ALERTS", style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _alertCard(QueryDocumentSnapshot data) {
    final time = data['time'] != null ? DateFormat('hh:mm:ss a').format(data['time'].toDate()) : '--:--';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.gpp_bad_rounded, color: Colors.redAccent, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['studentName'] ?? 'Student', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(data['reason'] ?? 'Violation', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(time, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.verified_user_rounded, size: 80, color: Colors.greenAccent),
          const SizedBox(height: 20),
          const Text("ZONE SECURE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
          Text("No violations detected", style: TextStyle(color: Colors.white.withOpacity(0.4))),
        ],
      ),
    );
  }
}