import '../entities/hadith_book.dart';
import '../entities/hadith_entity.dart';

abstract class HadithRepository {
  Future<HadithBookData> getBook(HadithBookType book);
}
