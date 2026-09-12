import 'hadith_book.dart';
import 'hadith_entity.dart';

class HadithIndexArgs {
  final HadithBookType book;

  const HadithIndexArgs({required this.book});
}

class HadithDetailsArgs {
  final HadithBookType book;
  final List<HadithItem> hadiths;
  final int initialIndex;
  final String headerTitle;
  final int totalCount;

  const HadithDetailsArgs({
    required this.book,
    required this.hadiths,
    required this.initialIndex,
    required this.headerTitle,
    required this.totalCount,
  });
}
