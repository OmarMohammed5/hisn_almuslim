class HadithSahih {
  final int id;
  final int hadithNumber;
  final String hadithTitle;
  final String hadithContent;

  HadithSahih({
    required this.id,
    required this.hadithNumber,
    required this.hadithTitle,
    required this.hadithContent,
  });

  factory HadithSahih.fromJson(Map<String, dynamic> json) {
    return HadithSahih(
      id: json['hadith_id'] ?? 0,
      hadithNumber: json['hadith_number'] ?? 0,
      hadithTitle: json['title'] ?? " ",
      hadithContent: json['content'] ?? "",
    );
  }

  void operator [](String other) {}
}
