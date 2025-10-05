import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class SparklineRow extends StatelessWidget {
  const SparklineRow({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(children: const [
      Expanded(child: SparkCard(title: 'Sentimiento (Pos %)')),
      SizedBox(width: 12),
      Expanded(child: SparkCard(title: 'Actividad (likes/día)')),
      SizedBox(width: 12),
      Expanded(child: SparkCard(title: 'Proxy de viralidad')),
    ]);
  }
}

class SparkCard extends StatelessWidget {
  final String title;
  const SparkCard({super.key, required this.title});

  List<FlSpot> _mock() => const [
    FlSpot(0, 10), FlSpot(1, 12), FlSpot(2, 8),
    FlSpot(3, 18), FlSpot(4, 16), FlSpot(5, 22),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(color: AppColors.surface, child: Padding(
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        height: 120,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
          SizedBox(height: 8),
          Expanded(child: LineChart(LineChartData(
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            lineBarsData: [LineChartBarData(
              isCurved: true,
              color: AppColors.accent,
              barWidth: 2,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: const LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [AppColors.accent, Color(0x003B82F6)],
                ),
              ),
              spots: _mock(),
            )],
          ))),
        ]),
      ),
    ));
  }
}
