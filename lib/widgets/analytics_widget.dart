import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsWidget extends StatelessWidget {
  final int total;
  final int online;
  final int locked;

  const AnalyticsWidget({
    super.key,
    required this.total,
    required this.online,
    required this.locked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        /// 🔥 PIE CHART
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: online.toDouble(),
                  color: Colors.green,
                  title: "Online",
                ),
                PieChartSectionData(
                  value: locked.toDouble(),
                  color: Colors.red,
                  title: "Locked",
                ),
                PieChartSectionData(
                  value: (total - online).toDouble(),
                  color: Colors.grey,
                  title: "Offline",
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        /// 📊 BAR DATA
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _stat("Total", total, Colors.white),
            _stat("Online", online, Colors.green),
            _stat("Locked", locked, Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _stat(String label, int value, Color color) {
    return Column(
      children: [
        Text("$value",
            style: TextStyle(fontSize: 20, color: color)),
        Text(label,
            style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}