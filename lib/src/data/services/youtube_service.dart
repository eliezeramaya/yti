import '../models/video_summary.dart';
import '../models/comment_item.dart';

abstract class YouTubeService {
  Future<List<VideoSummary>> fetchChannelVideos({required String channelId});
  Future<List<CommentItem>> fetchVideoComments({required String videoId});
  Future<VideoSummary?> fetchVideoByUrl(String url);
}
