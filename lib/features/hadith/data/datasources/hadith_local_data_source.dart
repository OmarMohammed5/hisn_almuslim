import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/hadith_book.dart';
import '../../domain/entities/hadith_entity.dart';

abstract class HadithLocalDataSource {
  Future<HadithBookData> loadBook(HadithBookType book);
}

class HadithLocalDataSourceImpl implements HadithLocalDataSource {
  @override
  Future<HadithBookData> loadBook(HadithBookType book) async {
    final jsonString = await rootBundle.loadString(
      HadithBook.fromType(book).assetPath,
    );

    return compute(
      parseHadithBook,
      _HadithParseRequest(jsonString: jsonString, book: book),
    );
  }
}

class _HadithParseRequest {
  final String jsonString;
  final HadithBookType book;

  const _HadithParseRequest({
    required this.jsonString,
    required this.book,
  });
}

HadithBookData parseHadithBook(_HadithParseRequest request) {
  final data = jsonDecode(request.jsonString) as Map<String, dynamic>;

  switch (request.book) {
    case HadithBookType.bukhary:
      return HadithBookData(
        book: request.book,
        chapters: _parseChapterBooks(data['chapters'] as List),
      );
    case HadithBookType.muslim:
      return HadithBookData(
        book: request.book,
        chapters: _parseChapterBooks(data['chapters'] as List),
      );
    case HadithBookType.riyadAlSaliheen:
      return HadithBookData(
        book: request.book,
        chapters: _parseChapterBooks(data['chapters'] as List),
      );
    case HadithBookType.nawawi:
      return HadithBookData(
        book: request.book,
        chapters: _parseNawawiChapters(data['hadithList'] as List),
      );
  }
}

List<HadithChapter> _parseChapterBooks(List rawChapters) {
  return rawChapters.map((raw) {
    final chapter = raw as Map<String, dynamic>;
    final rawHadiths = chapter['hadiths'] as List;

    return HadithChapter(
      id: chapter['chapter_id'] ?? 0,
      hadithsCount: chapter['hadiths_count'] ?? 0,
      title: chapter['chapter_title'] ?? '',
      hadiths: rawHadiths.map((rawHadith) {
        final hadith = rawHadith as Map<String, dynamic>;
        return HadithItem(
          id: hadith['hadith_id'] ?? 0,
          hadithNumber: hadith['hadith_number'] ?? 0,
          title: hadith['title'] ?? ' ',
          content: hadith['content'] ?? '',
        );
      }).toList(),
    );
  }).toList();
}

List<HadithChapter> _parseNawawiChapters(List rawHadiths) {
  return rawHadiths.map((raw) {
    final hadith = raw as Map<String, dynamic>;
    final contents = hadith['hadithContent'] as List;
    final arabicContent = contents.isNotEmpty
        ? contents.last as Map<String, dynamic>
        : const <String, dynamic>{};

    final id = hadith['id'] ?? 0;
    final item = HadithItem(
      id: id,
      hadithNumber: id,
      title: arabicContent['title'] ?? '',
      content: arabicContent['contenu'] ?? '',
    );

    return HadithChapter(
      id: id,
      hadithsCount: 1,
      title: item.title,
      hadiths: [item],
    );
  }).toList();
}
