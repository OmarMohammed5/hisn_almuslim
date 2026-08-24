class Lecture {
  final String id;
  final String title;
  final String description;
  final String channelId;
  final String channelName;
  final String thumbnailUrl;
  final DateTime publishedAt;
  final Duration duration;

  const Lecture({
    required this.id,
    required this.title,
    required this.description,
    required this.channelId,
    required this.channelName,
    required this.thumbnailUrl,
    required this.publishedAt,
    required this.duration,
  });
}
