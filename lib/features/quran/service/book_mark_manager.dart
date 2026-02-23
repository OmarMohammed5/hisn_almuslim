import 'package:shared_preferences/shared_preferences.dart';

class BookmarkManager {
  static const String _key = 'quran_bookmarks';

  static Future<void> saveBookmark(int page, String colorHex) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = prefs.getStringList(_key) ?? [];

    bookmarks.removeWhere((b) => b.startsWith('$page:'));
    bookmarks.add('$page:$colorHex');

    await prefs.setStringList(_key, bookmarks);
  }

  static Future<Map<int, String>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = prefs.getStringList(_key) ?? [];

    final Map<int, String> result = {};
    for (final b in bookmarks) {
      final parts = b.split(':');
      if (parts.length == 2) {
        result[int.parse(parts[0])] = parts[1];
      }
    }
    return result;
  }

  static Future<void> removeBookmark(int page) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = prefs.getStringList(_key) ?? [];
    bookmarks.removeWhere((b) => b.startsWith('$page:'));
    await prefs.setStringList(_key, bookmarks);
  }
}
