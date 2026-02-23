class ArabicSearchUtils {
  ArabicSearchUtils._();

  static String removeTashkeel(String text) {
    final tashkeelRegex = RegExp(r'[\u0617-\u061A\u064B-\u0652]');
    return text.replaceAll(tashkeelRegex, '');
  }

  static String normalizeArabic(String text) {
    return text
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ة', 'ه')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي');
  }

  static String clean(String text) {
    return normalizeArabic(removeTashkeel(text)).toLowerCase().trim();
  }

  static List<T> search<T>({
    required List<T> list,
    required String query,
    required String Function(T item) getText,
  }) {
    if (query.isEmpty) return list;

    final cleanedQuery = clean(query);

    return list.where((item) {
      final itemText = clean(getText(item));
      return itemText.contains(cleanedQuery);
    }).toList();
  }
}
