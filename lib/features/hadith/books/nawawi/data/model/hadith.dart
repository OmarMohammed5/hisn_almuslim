import 'package:hisn_almuslim/features/hadith/books/nawawi/data/model/hadith_content.dart';

class Hadith {
  final int id;

  final List<HadithContent> hadithContent;

  Hadith({required this.id, required this.hadithContent});

  factory Hadith.formJson(Map<String, dynamic> json) {
    return Hadith(
      id: json['id'],
      hadithContent: (json['hadithContent'] as List)
          .map((e) => HadithContent.fromJson(e))
          .toList(),
    );
  }
}
