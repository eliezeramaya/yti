class Env {
  static const youtubeKey = String.fromEnvironment('YOUTUBE_API_KEY', defaultValue: '');
  static const openAIKey  = String.fromEnvironment('OPENAI_API_KEY', defaultValue: '');
}
