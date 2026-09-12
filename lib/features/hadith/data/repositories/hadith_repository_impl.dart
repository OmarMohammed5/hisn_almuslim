import '../../domain/entities/hadith_book.dart';
import '../../domain/entities/hadith_entity.dart';
import '../../domain/repositories/hadith_repository.dart';
import '../datasources/hadith_local_data_source.dart';

class HadithRepositoryImpl implements HadithRepository {
  final HadithLocalDataSource localDataSource;

  const HadithRepositoryImpl({required this.localDataSource});

  @override
  Future<HadithBookData> getBook(HadithBookType book) {
    return localDataSource.loadBook(book);
  }
}
