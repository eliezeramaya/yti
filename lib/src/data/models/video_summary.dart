class VideoSummary {
  final String id;
  final String title;
  final int views;
  final int likes;
  final int comments;
  final int shares;
  final int? t1000Min;
  final int? t100Min;
  const VideoSummary({required this.id, required this.title, required this.views, required this.likes,
    required this.comments, required this.shares, this.t1000Min, this.t100Min});
}
