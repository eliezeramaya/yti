import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class SlidersCard extends StatelessWidget {
  final int wSpeed, wInter, wGrowth;
  final void Function(int,int,int) onChanged;
  const SlidersCard({super.key, required this.wSpeed, required this.wInter, required this.wGrowth, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Card(color: isLight ? Colors.white : AppColors.surface, child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Pesos de Viralidad', style: TextStyle(fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        _SliderRow(label: 'Velocidad', value: wSpeed, onChanged: (v)=> onChanged(v, wInter, wGrowth)),
        _SliderRow(label: 'Interacciones', value: wInter, onChanged: (v)=> onChanged(wSpeed, v, wGrowth)),
        _SliderRow(label: 'Crecimiento', value: wGrowth, onChanged: (v)=> onChanged(wSpeed, wInter, v)),
        SizedBox(height: 4),
        Text('Sugerido: 50/30/20', style: TextStyle(color: isLight ? Colors.black54 : AppColors.textMuted, fontSize: 12)),
      ]),
    ));
  }
}

class _SliderRow extends StatelessWidget {
  final String label; final int value; final ValueChanged<int> onChanged;
  const _SliderRow({required this.label, required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        SizedBox(width: 110, child: Text(label, style: TextStyle(color: isLight ? Colors.black54 : AppColors.textMuted))),
        Expanded(child: Slider(value: value.toDouble(), onChanged: (v)=> onChanged(v.round()), min: 0, max: 100)),
        SizedBox(width: 48, child: Text('$value%', textAlign: TextAlign.right)),
      ]),
    );
  }
}
