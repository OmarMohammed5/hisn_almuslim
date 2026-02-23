import 'package:hisn_almuslim/features/hadith/books/reyad%20al%20salehin/data/model/chapter_reyad_al_saliheen.dart';

class ReyadAlSaliheenResponse {
  final List<ChapterReyadAlSaliheen> chapter;

  ReyadAlSaliheenResponse(this.chapter);

  factory ReyadAlSaliheenResponse.fromJson(Map<String, dynamic> json) {
    return ReyadAlSaliheenResponse(
      (json['chapters'] as List)
          .map((e) => ChapterReyadAlSaliheen.fromJson(e))
          .toList(),
    );
  }
}
