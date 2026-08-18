import '../entities/surah_entity.dart';
import '../repositories/quran_repository.dart';

class GetAllSurahsUseCase {
  final QuranRepository repository;

  GetAllSurahsUseCase(this.repository);

  Future<List<SurahEntity>> call() async {
    return await repository.getAllSurahs();
  }
}