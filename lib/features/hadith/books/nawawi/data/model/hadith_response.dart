import 'package:hisn_almuslim/features/hadith/books/nawawi/data/model/hadith.dart';

class HadithResponse {
  final List<Hadith> hadithList;
  HadithResponse({required this.hadithList});

  factory HadithResponse.fromJson(Map<String, dynamic> json) {
    return HadithResponse(
      hadithList: (json['hadithList'] as List)
          .map((e) => Hadith.formJson(e))
          .toList(),
    );
  }
}
