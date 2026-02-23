import 'package:shared_preferences/shared_preferences.dart';

class QuranStorage {
  static const _pagesPerDayKey = 'pages_per_day';
  static const _completedPagesKey = 'completed_pages';

  Future<void> saveReading({
    required int pagesPerDay,
    required int completedPages,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_pagesPerDayKey, pagesPerDay);
    await prefs.setInt(_completedPagesKey, completedPages);
  }

  Future<Map<String, int>?> loadReading() async {
    final prefs = await SharedPreferences.getInstance();

    final pagesPerDay = prefs.getInt(_pagesPerDayKey);
    final completedPages = prefs.getInt(_completedPagesKey);

    if (pagesPerDay == null || completedPages == null) return null;

    return {'pagesPerDay': pagesPerDay, 'completedPages': completedPages};
  }

  Future<void> clearReading() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pagesPerDayKey);
    await prefs.remove(_completedPagesKey);
  }
}
