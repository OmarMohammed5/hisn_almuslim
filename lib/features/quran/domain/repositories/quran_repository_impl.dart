import '../../data/datasource/quran_local_data_source.dart';
import '../../data/models/ayah_model.dart';
import '../../data/models/surah_model.dart';
import '../../domain/entities/ayah_entity.dart';
import '../../domain/entities/surah_entity.dart';
import '../../domain/repositories/quran_repository.dart';

/// Implementation of QuranRepository
class QuranRepositoryImpl implements QuranRepository {
  final QuranLocalDataSource _localDataSource;
  final Map<int, SurahEntity> _surahCache = {};
  final Map<String, bool> _bookmarkCache = {};
  final Map<int, int> _progressCache = {};
  List<SurahEntity>? _allSurahsCache;

  // Track last read position
  Map<String, int>? _lastRead;

  QuranRepositoryImpl({
    required QuranLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  // ============ MAPPING METHODS ============

  /// Maps SurahModel to SurahEntity
  SurahEntity _mapToSurahEntity(SurahModel model) {
    return SurahEntity(
      number: model.number,
      name: model.name,
      nameSimplified: model.nameTextEmlaey,
      englishName: model.englishName,
      englishNameTranslation: model.englishNameTranslation,
      revelationType: model.revelationType,
      surahInfo: model.surahInfo,
      surahInfoFromBook: model.surahInfoFromBook,
      surahNames: model.surahNames,
      surahNamesFromBook: model.surahNamesFromBook,
      ayahs: model.ayahs.map(_mapToAyahEntity).toList(),
    );
  }

  /// Maps AyahModel to AyahEntity
  AyahEntity _mapToAyahEntity(AyahModel model) {
    return AyahEntity(
      number: model.number,
      text: model.text,
      textSimplified: model.ayaTextEmlaey,
      audioUrl: model.audio,
      audioSecondary: model.audioSecondary,
      numberInSurah: model.numberInSurah,
      juz: model.juz,
      manzil: model.manzil,
      page: model.page,
      pageInSurah: model.pageInSurah,
      ruku: model.ruku,
      hizbQuarter: model.hizbQuarter,
      isSajdah: model.sajda,
      codeV2: model.codeV2,
    );
  }

  // ============ CACHE MANAGEMENT ============

  /// Loads and caches all Surahs
  Future<void> _loadAndCacheAllSurahs() async {
    if (_allSurahsCache != null) {
      return;
    }

    final response = await _localDataSource.getQuran();
    final surahs = response.data.surahs.map(_mapToSurahEntity).toList();

    // Cache all Surahs
    _allSurahsCache = surahs;

    // Cache individual Surahs
    for (final surah in surahs) {
      _surahCache[surah.number] = surah;
    }
  }

  // ============ REPOSITORY METHODS ============

  @override
  Future<List<SurahEntity>> getAllSurahs() async {
    await _loadAndCacheAllSurahs();
    return _allSurahsCache!;
  }

  @override
  Future<SurahEntity> getSurahByNumber(int surahNumber) async {
    // Check cache first
    if (_surahCache.containsKey(surahNumber)) {
      return _surahCache[surahNumber]!;
    }

    // Load from data source
    await _loadAndCacheAllSurahs();

    // Check again after loading
    if (_surahCache.containsKey(surahNumber)) {
      return _surahCache[surahNumber]!;
    }

    throw Exception('Surah number $surahNumber not found');
  }

  @override
  Future<AyahEntity> getAyahByNumber(int surahNumber, int ayahNumber) async {
    final surah = await getSurahByNumber(surahNumber);

    final ayah = surah.ayahs.firstWhere(
          (ayah) => ayah.number == ayahNumber,
      orElse: () => throw Exception(
        'Ayah $ayahNumber not found in Surah $surahNumber',
      ),
    );

    return ayah;
  }

  @override
  Future<List<AyahEntity>> searchAyahs(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    await _loadAndCacheAllSurahs();

    final results = <AyahEntity>[];
    final searchLower = query.toLowerCase().trim();

    for (final surah in _allSurahsCache!) {
      for (final ayah in surah.ayahs) {
        // Search in both text versions
        if (ayah.text.contains(searchLower) ||
            ayah.textSimplified.contains(searchLower)) {
          results.add(ayah);
        }
      }
    }

    return results;
  }

  @override
  Future<int> getTotalSurahs() async {
    await _loadAndCacheAllSurahs();
    return _allSurahsCache!.length;
  }

  @override
  Future<int> getTotalAyahsInSurah(int surahNumber) async {
    final surah = await getSurahByNumber(surahNumber);
    return surah.totalAyahs;
  }

  @override
  Future<SurahEntity> getSurahByPage(int pageNumber) async {
    await _loadAndCacheAllSurahs();

    for (final surah in _allSurahsCache!) {
      if (surah.ayahs.isNotEmpty) {
        final firstAyah = surah.ayahs.first;
        final lastAyah = surah.ayahs.last;

        // Check if the page falls within this Surah's page range
        if (pageNumber >= firstAyah.page && pageNumber <= lastAyah.page) {
          return surah;
        }
      }
    }

    throw Exception('Page number $pageNumber not found');
  }

  @override
  Future<List<SurahEntity>> getSurahsByRevelationType(String revelationType) async {
    await _loadAndCacheAllSurahs();

    return _allSurahsCache!
        .where((surah) =>
    surah.revelationType.toLowerCase() == revelationType.toLowerCase())
        .toList();
  }

  // ============ BOOKMARK METHODS ============

  @override
  Future<bool> saveBookmark(int surahNumber, int ayahNumber) async {
    // For now, store in memory
    // In a real app, this would use shared_preferences or a database
    final key = '${surahNumber}_$ayahNumber';
    _bookmarkCache[key] = true;
    return true;
  }

  @override
  Future<bool> removeBookmark(int surahNumber, int ayahNumber) async {
    final key = '${surahNumber}_$ayahNumber';
    _bookmarkCache.remove(key);
    return true;
  }

  @override
  Future<List<AyahEntity>> getBookmarks() async {
    final bookmarks = <AyahEntity>[];

    for (final key in _bookmarkCache.keys) {
      final parts = key.split('_');
      if (parts.length == 2) {
        final surahNumber = int.parse(parts[0]);
        final ayahNumber = int.parse(parts[1]);

        try {
          final ayah = await getAyahByNumber(surahNumber, ayahNumber);
          bookmarks.add(ayah);
        } catch (e) {
          // Skip if ayah not found
        }
      }
    }

    return bookmarks;
  }

  @override
  Future<bool> isBookmarked(int surahNumber, int ayahNumber) async {
    final key = '${surahNumber}_$ayahNumber';
    return _bookmarkCache.containsKey(key);
  }

  // ============ READING PROGRESS METHODS ============

  @override
  Future<bool> saveLastRead(int surahNumber, int ayahNumber) async {
    _lastRead = {
      'surahNumber': surahNumber,
      'ayahNumber': ayahNumber,
    };
    return true;
  }

  @override
  Future<Map<String, int>?> getLastRead() async {
    return _lastRead;
  }

  @override
  Future<double> getSurahProgress(int surahNumber) async {
    final surah = await getSurahByNumber(surahNumber);

    // If progress is saved for this Surah
    if (_progressCache.containsKey(surahNumber)) {
      final lastReadAyah = _progressCache[surahNumber]!;
      return lastReadAyah / surah.totalAyahs;
    }

    return 0.0;
  }

  @override
  Future<bool> updateSurahProgress(int surahNumber, int ayahNumber) async {
    final surah = await getSurahByNumber(surahNumber);

    // Validate ayah number
    if (ayahNumber < 1 || ayahNumber > surah.totalAyahs) {
      return false;
    }

    _progressCache[surahNumber] = ayahNumber;
    return true;
  }

  // ============ CACHE METHODS ============

  @override
  Future<void> preloadQuran() async {
    await _loadAndCacheAllSurahs();
  }

  @override
  void clearCache() {
    _allSurahsCache = null;
    _surahCache.clear();
    _bookmarkCache.clear();
    _progressCache.clear();
    _lastRead = null;
    _localDataSource.clearCache();
  }

  @override
  bool isDataCached() {
    return _allSurahsCache != null;
  }
}