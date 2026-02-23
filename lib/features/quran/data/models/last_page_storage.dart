import 'package:shared_preferences/shared_preferences.dart';

class LastPageStorage {
  static const _lastPageKey = 'last_read_page';

  static Future<void> savePage(int page) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastPageKey, page);
  }

  static Future<int> loadPage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_lastPageKey) ?? 0;
  }
}
