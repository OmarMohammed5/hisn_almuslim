class DailyContentModel {
  final String content;
  final String source;

  const DailyContentModel({
    required this.content,
    required this.source,
  });

  factory DailyContentModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DailyContentModel(
      content: json['content'] as String,
      source: json['source'] as String,
    );
  }
}