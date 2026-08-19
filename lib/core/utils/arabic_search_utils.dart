class ArabicSearchUtils {

  static String normalizeArabic(String text) {
    return text
    // Remove Arabic Tashkeel / Diacritics
        .replaceAll(
      RegExp(r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED]'),
      '',
    )

    // Remove Tatweel
        .replaceAll('ـ', '')

    // Normalize Alef variations
        .replaceAll(RegExp(r'[أإآٱ]'), 'ا')

    // Normalize Alef Maqsura
        .replaceAll('ى', 'ي')

    // Normalize Waw with Hamza
        .replaceAll('ؤ', 'و')

    // Normalize Ya with Hamza
        .replaceAll('ئ', 'ي')

    // Normalize Ta Marbuta
        .replaceAll('ة', 'ه')

    // Normalize multiple spaces
        .replaceAll(RegExp(r'\s+'), ' ')

        .trim()
        .toLowerCase();
  }

  static bool matches({
    required String title,
    required String query,
  }) {
    final normalizedQuery = normalizeArabic(query);

    // Empty query means show all results.
    if (normalizedQuery.isEmpty) {
      return true;
    }

    final normalizedTitle = normalizeArabic(title);

    // Full phrase match.
    if (normalizedTitle.contains(normalizedQuery)) {
      return true;
    }

    // Word-by-word match.
    final queryWords = normalizedQuery
        .split(' ')
        .where((word) => word.isNotEmpty)
        .toList();

    return queryWords.every(
          (word) => normalizedTitle.contains(word),
    );
  }
}