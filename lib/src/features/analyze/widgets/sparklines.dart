import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class SparklineRow extends StatelessWidget {
  final List<FlSpot> posSeries;
  final List<FlSpot> likesSeries;
  final List<FlSpot> viralSeries;
  const SparklineRow({super.key, required this.posSeries, required this.likesSeries, required this.viralSeries});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: SparkCard(title: 'Sentimiento (Pos %)', spots: posSeries)),
      const SizedBox(width: 12),
      Expanded(child: SparkCard(title: 'Actividad (likes/día)', spots: likesSeries)),
      const SizedBox(width: 12),
      Expanded(child: SparkCard(title: 'Proxy de viralidad', spots: viralSeries)),
    ]);
  }
}

class SparkCard extends StatelessWidget {
  final String title;
  final List<FlSpot> spots;
  const SparkCard({super.key, required this.title, required this.spots});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Card(color: isLight ? Colors.white : AppColors.surface, child: Padding(
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        height: 120,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(color: isLight ? Colors.black54 : AppColors.textMuted, fontSize: 12)),
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
              spots: spots.isEmpty ? const [FlSpot(0,0)] : spots,
            )],
          ))),
        ]),
      ),
    ));
  }
}
