import 'hadith_book.dart';

class HadithItem {
  final int id;
  final int hadithNumber;
  final String title;
  final String content;

  const HadithItem({
    required this.id,
    required this.hadithNumber,
    required this.title,
    required this.content,
  });
}

class HadithChapter {
  final int id;
  final int hadithsCount;
  final String title;
  final List<HadithItem> hadiths;

  const HadithChapter({
    required this.id,
    required this.hadithsCount,
    required this.title,
    required this.hadiths,
  });
}

class HadithBookData {
  final HadithBookType book;
  final List<HadithChapter> chapters;

  const HadithBookData({
    required this.book,
    required this.chapters,
  });
}
