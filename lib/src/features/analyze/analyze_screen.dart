import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/metrics.dart';
import '../../data/services/mock_services.dart';
import '../../data/repositories/youtube_repository.dart';
import 'widgets/sparklines.dart';
import 'widgets/sliders_card.dart';

final repoProvider = Provider((ref) => YouTubeRepository(MockYouTubeService(), MockAIService()));

class AnalyzeScreen extends ConsumerStatefulWidget {
  const AnalyzeScreen({super.key});
  @override
  ConsumerState<AnalyzeScreen> createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends ConsumerState<AnalyzeScreen> {
  final ctrl = TextEditingController();
  Map<String, num>? _kpi;
  int wSpeed = 50, wInter = 30, wGrowth = 20;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Card(color: AppColors.surface, child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Expanded(child: TextField(
              controller: ctrl,
              decoration: const InputDecoration(hintText: 'Pega la URL de YouTube…', border: InputBorder.none),
            )),
            FilledButton(onPressed: () async {
              final repo = ref.read(repoProvider);
              final (video, comments, breakdown) = await repo.analyzeByUrl(ctrl.text);
              final daily = <Map<String,num>>[];
              for (final c in comments) {
                final k = DateTime(c.date.year,c.date.month,c.date.day).toString();
                final i = daily.indexWhere((e)=> e['key']==k);
                if (i==-1) { daily.add({'key': k, 'likes': c.likes}); }
                else { daily[i]['likes'] = (daily[i]['likes'] as num) + c.likes; }
              }
              final vir = viralityWeighted(
                views: video.views, likes: video.likes, comments: video.comments, shares: video.shares,
                t1000Min: video.t1000Min, t100Min: video.t100Min,
                dailyLikes: daily.map((e)=> {'likes': e['likes']!}).toList(),
                wSpeed: wSpeed/100, wInter: wInter/100, wGrowth: wGrowth/100,
              );
              setState(()=> _kpi = {
                'views': video.views, 'likes': video.likes, 'comments': video.comments,
                'viralidad': vir.score, 'pos': (breakdown.pos*100).round(), 'spam': (breakdown.spam*100).round(),
              });
            }, child: const Text('Analizar')),
          ]),
        )),
        const SizedBox(height: 16),
        if (_kpi != null) ...[
          Row(children: [
            Expanded(child: _KPIBox(label: 'Vistas', value: '${_kpi!['views']}')),
            SizedBox(width: 12),
            Expanded(child: _KPIBox(label: 'Likes', value: '${_kpi!['likes']}')),
            SizedBox(width: 12),
            Expanded(child: _KPIBox(label: 'Viralidad', value: '${_kpi!['viralidad']}')),
          ]),
          const SizedBox(height: 16),
          SlidersCard(wSpeed: wSpeed, wInter: wInter, wGrowth: wGrowth, onChanged: (a,b,c)=> setState((){ wSpeed=a; wInter=b; wGrowth=c; })),
          const SizedBox(height: 16),
          const SparklineRow(),
        ],
      ],
    );
  }
}

class _KPIBox extends StatelessWidget {
  final String label; final String value;
  const _KPIBox({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Card(color: AppColors.surface, child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
        SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
      ]),
    ));
  }
}
