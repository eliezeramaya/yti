import '../models/comment_item.dart';

class SentimentBreakdown {
  final double pos, neu, neg, spam;
  const SentimentBreakdown(this.pos,this.neu,this.neg,this.spam);
}

abstract class AIService {
  Future<SentimentBreakdown> analyzeSentiment(List<CommentItem> comments);
}
