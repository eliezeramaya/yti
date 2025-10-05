import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'widgets/kpi_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        Row(children: [
          Expanded(child: KPIBig(label: 'Viralidad', value: '78')),
          SizedBox(width: 12),
          Expanded(child: KPIChip(label: 'Sent Pos', value: '62%')),
          SizedBox(width: 12),
          Expanded(child: KPIChip(label: 'Engagement', value: '3.2%')),
        ]),
        SizedBox(height: 16),
        Card(color: AppColors.surface, child: SizedBox(height: 200, child: Center(child: Text('Gráfica canal (placeholder)')))),
        SizedBox(height: 16),
        Card(color: AppColors.surface, child: SizedBox(height: 260, child: Center(child: Text('Tabla de videos (placeholder)')))),
      ],
    );
  }
}
