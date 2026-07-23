import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsPage extends StatefulWidget {
  final String classId;

  const AnalyticsPage({super.key, required this.classId});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _fade = Tween(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {

    final parts = widget.classId.split("_");

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        title: const Text("📊 AI Analytics"),
        backgroundColor: Colors.transparent,
      ),

      body: FadeTransition(
        opacity: _fade,

        child: StreamBuilder(
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

            int total = docs.length;
            int online = docs.where((d)=>d['online']==true).length;
            int locked = docs.where((d)=>d['teachingMode']==true).length;

            /// 🧠 AI PREDICTION
            double risk = total == 0 ? 0 :
            ((online - locked) / total) * 100;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [

                  /// 🔥 STATS CARDS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _card("Total", total, Colors.white),
                      _card("Online", online, Colors.green),
                      _card("Locked", locked, Colors.red),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// 📊 PIE CHART
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                              value: online.toDouble(),
                              color: Colors.green,
                              title: "Online"),
                          PieChartSectionData(
                              value: (total - online).toDouble(),
                              color: Colors.grey,
                              title: "Offline"),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// 📊 BAR CHART
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        barGroups: [
                          BarChartGroupData(x: 0, barRods: [
                            BarChartRodData(toY: online.toDouble())
                          ]),
                          BarChartGroupData(x: 1, barRods: [
                            BarChartRodData(toY: locked.toDouble())
                          ]),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// 🤖 AI RISK METER
                  Column(
                    children: [
                      const Text("AI Cheating Risk",
                          style: TextStyle(color: Colors.white)),

                      const SizedBox(height: 10),

                      LinearProgressIndicator(
                        value: risk / 100,
                        color: Colors.red,
                        backgroundColor: Colors.white12,
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "${risk.toStringAsFixed(1)}%",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _card(String title, int value, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          Text("$value",
              style: TextStyle(
                  color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}