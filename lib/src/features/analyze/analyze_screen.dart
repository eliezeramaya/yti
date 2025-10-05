import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/metrics.dart';
import '../../data/services/mock_services.dart';
import '../../data/repositories/youtube_repository.dart';
import 'widgets/sparklines.dart';
import 'package:fl_chart/fl_chart.dart';
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
  List<FlSpot> _posSeries = const [];
  List<FlSpot> _likesSeries = const [];
  List<FlSpot> _viralSeries = const [];
  int wSpeed = 50, wInter = 30, wGrowth = 20;

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Card(color: Theme.of(context).brightness==Brightness.light? Colors.white : AppColors.surface, child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Expanded(child: TextField(
              controller: ctrl,
              decoration: const InputDecoration(hintText: 'Pega la URL de YouTube…', border: InputBorder.none),
            )),
            FilledButton(onPressed: () async {
              final repo = ref.read(repoProvider);
              final (video, comments, breakdown) = await repo.analyzeByUrl(ctrl.text);
              final daily = <String, Map<String, num>>{};
              for (final c in comments) {
                final k = DateTime(c.date.year,c.date.month,c.date.day).toString();
                final e = daily.putIfAbsent(k, ()=> {'likes':0,'pos':0,'total':0});
                e['likes'] = (e['likes'] ?? 0) + c.likes;
                e['total'] = (e['total'] ?? 0) + 1;
                if (c.sentiment=='pos' && !c.spam) e['pos'] = (e['pos'] ?? 0) + 1;
              }
              final keys = daily.keys.toList()..sort();
              final posSpots = <FlSpot>[];
              final likesSpots = <FlSpot>[];
              final viralSpots = <FlSpot>[];
              for (var i=0; i<keys.length; i++) {
                final e = daily[keys[i]]!;
                final posPct = (e['total']==0?0.0: (e['pos']!/ e['total']!) * 100.0);
                posSpots.add(FlSpot(i.toDouble(), posPct.toDouble()));
                likesSpots.add(FlSpot(i.toDouble(), (e['likes']!).toDouble()));
              }
              // Viral proxy: normaliza likes y pos% a 0..1 y promedia
              double norm(List<FlSpot> s){
                if (s.isEmpty) return 0;
                final ys = s.map((e)=> e.y).toList();
                final minY = ys.reduce((a,b)=> a<b?a:b);
                final maxY = ys.reduce((a,b)=> a>b?a:b);
                final range = (maxY-minY)==0?1:(maxY-minY);
                return (s.last.y - minY)/range;
              }
              final vVal = (norm(likesSpots) + norm(posSpots))/2;
              for (var i=0; i<likesSpots.length; i++) {
                viralSpots.add(FlSpot(i.toDouble(), vVal*100));
              }
              final vir = viralityWeighted(
                views: video.views, likes: video.likes, comments: video.comments, shares: video.shares,
                t1000Min: video.t1000Min, t100Min: video.t100Min,
                dailyLikes: keys.map((k)=> {'likes': daily[k]!['likes'] as num}).toList(),
                wSpeed: wSpeed/100, wInter: wInter/100, wGrowth: wGrowth/100,
              );
              setState((){
                _kpi = {
                  'views': video.views, 'likes': video.likes, 'comments': video.comments,
                  'viralidad': vir.score, 'pos': (breakdown.pos*100).round(), 'spam': (breakdown.spam*100).round(),
                };
                _posSeries = posSpots;
                _likesSeries = likesSpots;
                _viralSeries = viralSpots;
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
          SparklineRow(posSeries: _posSeries, likesSeries: _likesSeries, viralSeries: _viralSeries),
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
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Card(color: isLight ? Colors.white : AppColors.surface, child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(color: isLight ? Colors.black54 : AppColors.textMuted, fontSize: 12)),
        SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
      ]),
    ));
  }
}
