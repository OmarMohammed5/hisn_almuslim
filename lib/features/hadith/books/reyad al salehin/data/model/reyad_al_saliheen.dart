class ReyadAlSaliheen {
  final int hadithId;
  final int hadithNumber;
  final String hadithTitle;
  final String hadithContent;

  ReyadAlSaliheen({
    required this.hadithId,
    required this.hadithNumber,
    required this.hadithTitle,
    required this.hadithContent,
  });

  factory ReyadAlSaliheen.fromJson(Map<String, dynamic> json) {
    return ReyadAlSaliheen(
      hadithId: json['hadith_id'] ?? 0,
      hadithNumber: json['hadith_number'] ?? 0,
      hadithTitle: json['title'] ?? " ",
      hadithContent: json['content'] ?? " ",
    );
  }
}
