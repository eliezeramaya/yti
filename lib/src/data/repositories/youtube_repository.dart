import '../models/video_summary.dart';
import '../models/comment_item.dart';
import '../services/youtube_service.dart';
import '../services/ai_service.dart';

class YouTubeRepository {
  final YouTubeService yt; final AIService ai;
  const YouTubeRepository(this.yt, this.ai);

  Future<(VideoSummary, List<CommentItem>, SentimentBreakdown)> analyzeByUrl(String url) async {
    final video = await yt.fetchVideoByUrl(url);
    if (video == null) { throw Exception('Video no encontrado'); }
    final comments = await yt.fetchVideoComments(videoId: video.id);
    final breakdown = await ai.analyzeSentiment(comments);
    return (video, comments, breakdown);
  }
}
