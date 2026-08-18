//
//
// import '../../data/models/ayah_model.dart';
// import '../../data/models/surah_model.dart';
//
// abstract class QuranRepository {
//
//
//   Future<List<SurahModel>> getAllSurahs();
//
//
//   Future<SurahModel> getSurahByNumber(int surahNumber);
//
//
//   Future<AyahModel> getAyahByNumber(int surahNumber, int ayahNumber);
//
//
//   Future<List<AyahModel>> searchAyahs(String query);
//
//
//   Future<int> getTotalSurahs();
//
//
//   Future<int> getTotalAyahsInSurah(int surahNumber);
//
//
//   Future<SurahModel> getSurahByPage(int pageNumber);
//
//
//   Future<List<SurahModel>> getSurahsByRevelationType(String revelationType);
//
//
//   // ============ BOOKMARK METHODS ============
//
//
//   Future<bool> saveBookmark(int surahNumber, int ayahNumber);
//
//
//   Future<bool> removeBookmark(int surahNumber, int ayahNumber);
//
//
//   Future<List<AyahModel>> getBookmarks();
//
//
//
//   Future<bool> isBookmarked(int surahNumber, int ayahNumber);
//
//   // ============ READING PROGRESS METHODS ============
//
//
//
//   Future<bool> saveLastRead(int surahNumber, int ayahNumber);
//
//
//   Future<Map<String, int>?> getLastRead();
//
//
//   Future<double> getSurahProgress(int surahNumber);
//
//
//
//   Future<bool> updateSurahProgress(int surahNumber, int ayahNumber);
//
//   // ============ CACHE METHODS ============
//
//
//   Future<void> preloadQuran();
//
//
//   void clearCache();
//
//
//   bool isDataCached();
// }
import '../entities/ayah_entity.dart';
import '../entities/surah_entity.dart';

abstract class QuranRepository {
  Future<List<SurahEntity>> getAllSurahs();

  Future<SurahEntity> getSurahByNumber(int surahNumber);

  Future<AyahEntity> getAyahByNumber(int surahNumber, int ayahNumber);

  Future<List<AyahEntity>> searchAyahs(String query);

  Future<int> getTotalSurahs();

  Future<int> getTotalAyahsInSurah(int surahNumber);

  Future<SurahEntity> getSurahByPage(int pageNumber);

  Future<List<SurahEntity>> getSurahsByRevelationType(String revelationType);

  // ============ BOOKMARK METHODS ============

  Future<bool> saveBookmark(int surahNumber, int ayahNumber);

  Future<bool> removeBookmark(int surahNumber, int ayahNumber);

  Future<List<AyahEntity>> getBookmarks();

  Future<bool> isBookmarked(int surahNumber, int ayahNumber);

  // ============ READING PROGRESS METHODS ============

  Future<bool> saveLastRead(int surahNumber, int ayahNumber);

  Future<Map<String, int>?> getLastRead();

  Future<double> getSurahProgress(int surahNumber);

  Future<bool> updateSurahProgress(int surahNumber, int ayahNumber);

  // ============ CACHE METHODS ============

  Future<void> preloadQuran();

  void clearCache();

  bool isDataCached();
}