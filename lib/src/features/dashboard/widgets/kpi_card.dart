import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class KPIBig extends StatelessWidget {
  final String label; final String value;
  const KPIBig({super.key, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: isLight ? Colors.black54 : AppColors.textMuted, fontSize: 12)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
        ]),
      ),
    );
  }
}

class KPIChip extends StatelessWidget {
  final String label; final String value;
  const KPIChip({super.key, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Expanded(
            child: Text(label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: isLight ? Colors.black54 : AppColors.textMuted, fontSize: 12)),
          ),
          const SizedBox(width: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}
