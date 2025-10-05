class CommentItem {
  final String id;
  final String text;
  final int likes;
  final DateTime date;
  final String sentiment; // pos/neu/neg
  final bool spam;
  const CommentItem({required this.id, required this.text, required this.likes, required this.date, required this.sentiment, this.spam=false});
}
