import '../models/quran_response_model.dart';

abstract class QuranLocalDataSource {
  Future<QuranResponseModel> loadQuran();

  /// Gets cached Quran data if available
  Future<QuranResponseModel> getQuran();

  /// Clears the cached data
  void clearCache();

  /// Checks if data is cached
  bool isDataCached();
}