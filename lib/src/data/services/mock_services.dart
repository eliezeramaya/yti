import 'dart:math';
import '../models/video_summary.dart';
import '../models/comment_item.dart';
import 'youtube_service.dart';
import 'ai_service.dart';

class MockYouTubeService implements YouTubeService {
  final _rnd = Random();
  @override
  Future<List<VideoSummary>> fetchChannelVideos({required String channelId}) async {
    return List.generate(6, (i)=> VideoSummary(
      id: 'vid_$i', title: 'Video $i',
      views: 20000 + _rnd.nextInt(80000),
      likes: 1000 + _rnd.nextInt(4000),
      comments: 200 + _rnd.nextInt(800),
      shares: 100 + _rnd.nextInt(600),
      t1000Min: 60 + _rnd.nextInt(600),
    ));
  }

  @override
  Future<List<CommentItem>> fetchVideoComments({required String videoId}) async {
    final now = DateTime.now();
    return List.generate(80, (i)=> CommentItem(
      id: 'c$i', text: i % 9 == 0 ? 'Visiten mi canal' : 'Excelente',
      likes: _rnd.nextInt(50),
      date: now.subtract(Duration(days: _rnd.nextInt(7))),
      sentiment: i % 5 == 0 ? 'neg' : (i % 3 == 0 ? 'neu' : 'pos'),
      spam: i % 9 == 0,
    ));
  }

  @override
  Future<VideoSummary?> fetchVideoByUrl(String url) async {
    return VideoSummary(id: 'vid_ext', title: 'Video externo (mock)',
      views: 45231, likes: 2310, comments: 320, shares: 580, t1000Min: 300);
  }
}

class MockAIService implements AIService {
  @override
  Future<SentimentBreakdown> analyzeSentiment(List<CommentItem> comments) async {
    final total = comments.where((c)=> !c.spam).length;
    if (total == 0) return const SentimentBreakdown(0.33,0.34,0.33,0.0);
    final pos = comments.where((c)=> c.sentiment=='pos').length/total;
    final neu = comments.where((c)=> c.sentiment=='neu').length/total;
    final neg = comments.where((c)=> c.sentiment=='neg').length/total;
    final spam = comments.where((c)=> c.spam).length / comments.length;
    return SentimentBreakdown(pos, neu, neg, spam);
  }
}
