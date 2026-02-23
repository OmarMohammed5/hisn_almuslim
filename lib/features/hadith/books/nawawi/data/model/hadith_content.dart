class HadithContent {
  final String title;
  final String contenu;

  HadithContent({required this.title, required this.contenu});

  factory HadithContent.fromJson(Map<String, dynamic> json) {
    return HadithContent(title: json['title'], contenu: json['contenu']);
  }
}
