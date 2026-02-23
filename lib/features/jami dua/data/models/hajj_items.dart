class HajjItems {
  final int id;
  final String title;
  final String content;

  HajjItems({required this.id, required this.title, required this.content});

  factory HajjItems.fromJson(Map<String, dynamic> json) {
    return HajjItems(
      id: json['id'] ?? 0,
      title: json['title'] ?? ' ',
      content: json['text'] ?? '',
    );
  }
}
