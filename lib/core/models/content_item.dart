/// Content of Zekr
class ContentItem {
  final String text;
  final String count;
  final String fadl;
  final String source;

  ContentItem({
    required this.text,
    required this.count,
    required this.fadl,
    required this.source,
  });

  factory ContentItem.fromJson(Map<String, dynamic> json) {
    return ContentItem(
      text: json["text"] ?? "",
      count: json["count"] ?? "0",
      fadl: json["fadl"] ?? "",
      source: json["source"] ?? "",
    );
  }
}

/// Title  of Zekr
class Zekr {
  final String title;
  final String count;
  final String bookmark;
  final List<ContentItem> content;

  Zekr({
    required this.title,
    required this.count,
    required this.bookmark,
    required this.content,
  });

  factory Zekr.fromJson(Map<String, dynamic> json) {
    return Zekr(
      title: json["title"] ?? "",
      count: json["count"] ?? "0",
      bookmark: json["bookmark"] ?? "0",
      content: (json["content"] as List)
          .map((e) => ContentItem.fromJson(e))
          .toList(),
    );
  }
}
