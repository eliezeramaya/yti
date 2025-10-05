double clamp01(double x) => x.clamp(0.0, 1.0);

double speedNorm({int? t1000Min, int? t100Min}) {
  const MAX_1000_MIN = 24*60;
  const LIMIT_48H = 48*60;
  const MAX_100_MIN = 6*60;
  if (t1000Min != null) {
    if (t1000Min > LIMIT_48H) {
      final effectiveT100 = t100Min ?? MAX_100_MIN;
      final base = 1 - (effectiveT100 / MAX_100_MIN).clamp(0.0, 1.0);
      return base * 0.8;
    }
    return 1 - (t1000Min / MAX_1000_MIN).clamp(0.0, 1.0);
  }
  if (t100Min != null) {
    final base = 1 - (t100Min / MAX_100_MIN).clamp(0.0, 1.0);
    return base * 0.8;
  }
  return 0;
}

double interactionsNorm({required int views, int likes=0, int comments=0, int shares=0}) {
  final v = views <= 0 ? 1 : views;
  final ratio = (likes + comments + shares) / v;
  const cap = 0.2;
  final norm = ratio / cap;
  return norm.clamp(0.0, 1.0);
}

double growthNormFromLikes(List<Map<String, num>> dailyLikes) {
  if (dailyLikes.length < 2) return 0;
  final mid = dailyLikes.length ~/ 2;
  final s1 = dailyLikes.sublist(0, mid).fold<num>(0, (a,b)=> a + b['likes']!.toDouble());
  final s2 = dailyLikes.sublist(mid).fold<num>(0, (a,b)=> a + b['likes']!.toDouble());
  final total = s1 + s2;
  if (total == 0) return 0;
  final accel = (s2 - s1) / total; // -1..1
  return ((accel + 1) / 2).clamp(0.0, 1.0);
}

/// Engagement rate as percentage [0..100].
double engagementRatePercent({required int views, int likes=0, int comments=0, int shares=0}) {
  if (views <= 0) return 0;
  final total = likes + comments + shares;
  return 100.0 * total / views;
}

class ViralityParts { final double speed, interactions, growth; const ViralityParts(this.speed,this.interactions,this.growth); }
class ViralityScore { final int score; final ViralityParts parts; final (double,double,double) weights; const ViralityScore(this.score,this.parts,this.weights); }

ViralityScore viralityWeighted({
  required int views, int likes=0, int comments=0, int shares=0,
  int? t1000Min, int? t100Min, List<Map<String, num>> dailyLikes = const [],
  double wSpeed=0.5, double wInter=0.3, double wGrowth=0.2,
}) {
  final sum = (wSpeed + wInter + wGrowth);
  final nws = (wSpeed / (sum == 0 ? 1 : sum));
  final nwi = (wInter / (sum == 0 ? 1 : sum));
  final nwg = (wGrowth / (sum == 0 ? 1 : sum));
  final s = speedNorm(t1000Min: t1000Min, t100Min: t100Min);
  final i = interactionsNorm(views: views, likes: likes, comments: comments, shares: shares);
  final g = growthNormFromLikes(dailyLikes);
  final score = 100 * (nws*s + nwi*i + nwg*g);
  return ViralityScore(score.round(), ViralityParts(s,i,g), (nws,nwi,nwg));
}
