class SurahModel {
  final int imageIndex;
  final int number; // عدد الآيات
  final String name;
  final int startPage;
  final String type; // مكية أو مدنية

  SurahModel({
    required this.imageIndex,
    required this.number,
    required this.name,
    required this.startPage,
    required this.type,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      imageIndex: json['imageIndex'],
      number: json['number'],
      name: json['name'],
      startPage: json['startPage'],
      type: json['type'],
    );
  }

  int getPagesCount(int nextSurahStartPage) {
    return nextSurahStartPage - startPage;
  }

  String getPagePath(int pageNumber) {
    return 'assets/quran/Image${pageNumber.toString().padLeft(2, '0')}.png';
  }

  // String getPagePath(int pageNumber) {
  //   return 'assets/quran/$pageNumber.png'; // بدون أي padding
  // }
}
