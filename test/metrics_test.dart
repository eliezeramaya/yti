import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_yti_pro/src/core/utils/metrics.dart';

void main() {
  test('speed fallback 48h == 6h@100 fallback', () {
    final late48 = speedNorm(t1000Min: 3000);
    final assume100 = speedNorm(t100Min: 360);
    expect((late48 - assume100).abs() <= 0.001, true);
  });

  test('interactions cap at 1', () {
    final norm = interactionsNorm(views: 1000, likes: 1000, comments: 1000, shares: 1000);
    expect(norm, 1.0);
  });

  test('growth halves comparison', () {
    final up = growthNormFromLikes([
      {'likes': 1}, {'likes': 1}, {'likes': 5}, {'likes': 7},
    ]);
    final flat = growthNormFromLikes([
      {'likes': 3}, {'likes': 3}, {'likes': 3}, {'likes': 3},
    ]);
    final down = growthNormFromLikes([
      {'likes': 7}, {'likes': 5}, {'likes': 1}, {'likes': 1},
    ]);
    expect(up > 0.5, true);
    expect((flat - 0.5).abs() < 0.01, true);
    expect(down < 0.5, true);
  });

  test('viralityWeighted range and weights sum to 1', () {
    final res = viralityWeighted(
      views: 100000, likes: 3000, comments: 800, shares: 1200, t1000Min: 180,
      dailyLikes: [{'likes':10},{'likes':12},{'likes':25},{'likes':30}],
      wSpeed: 0.5, wInter: 0.3, wGrowth: 0.2,
    );
    final sum = res.weights.$1 + res.weights.$2 + res.weights.$3;
    expect((sum - 1).abs() < 1e-9, true);
    expect(res.score >= 0 && res.score <= 100, true);
  });
}
