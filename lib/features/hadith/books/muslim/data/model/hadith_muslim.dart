class HadithMuslim {
  final int id;
  final int hadithNumber;
  final String title;
  final String content;

  HadithMuslim({
    required this.id,
    required this.hadithNumber,
    required this.title,
    required this.content,
  });

  factory HadithMuslim.fromJson(Map<String, dynamic> json) {
    return HadithMuslim(
      id: json['hadith_id'] ?? 0,
      hadithNumber: json['hadith_number'] ?? 0,
      title: json['title'] ?? " ",
      content: json['content'] ?? " ",
    );
  }
}
