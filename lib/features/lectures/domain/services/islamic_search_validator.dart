class IslamicSearchValidator {
  const IslamicSearchValidator._();

  // These keywords define the hard boundary of each category.
  // A result is accepted only when it contains at least one keyword
  // from the requested category.
  static const Map<String, List<String>> _categories = {
    'القرآن والتفسير': [
      'قرآن', 'القرآن', 'تفسير', 'سورة', 'آية', 'ايات', 'آيات',
      'تدبر', 'تلاوة', 'تجويد', 'حفظ القرآن', 'قصص القرآن',
    ],
    'الحديث والسنة': [
      'حديث', 'أحاديث', 'السنة', 'سنة', 'البخاري', 'بخاري', 'مسلم',
      'الترمذي', 'ترمذي', 'النسائي', 'نسائي', 'أبو داود', 'ابو داود',
      'ابن ماجه', 'شرح الحديث', 'الأربعين النووية', 'الاربعين النووية',
    ],
    'الفقه': [
      'فقه', 'صلاة', 'الصلاة', 'صيام', 'الصيام', 'صوم', 'زكاة', 'الزكاة',
      'حج', 'الحج', 'عمرة', 'العمرة', 'وضوء', 'الوضوء', 'طهارة',
      'حلال', 'حرام', 'أحكام', 'احكام', 'فتوى', 'فتاوى',
    ],
    'العقيدة': [
      'عقيدة', 'العقيدة', 'توحيد', 'التوحيد', 'ايمان', 'إيمان', 'شرك',
      'الأسماء والصفات', 'الاسماء والصفات', 'الولاء والبراء',
    ],
    'السيرة النبوية': [
      'السيرة', 'سيرة', 'النبي', 'الرسول', 'الصحابة', 'صحابة',
      'غزوة', 'غزوات', 'الهجرة', 'هجرة', 'الخلفاء الراشدين',
    ],
    'قصص الأنبياء': [
      'الأنبياء', 'أنبياء', 'الانبياء', 'قصص الأنبياء', 'قصص الانبياء',
      'آدم', 'ادم', 'نوح', 'إبراهيم', 'ابراهيم', 'موسى', 'عيسى',
      'يوسف', 'يونس', 'يعقوب', 'اسماعيل', 'إسماعيل',
    ],
    'الأخلاق والآداب': [
      'أخلاق', 'اخلاق', 'آداب', 'اداب', 'بر الوالدين', 'الوالدين',
      'صلة الرحم', 'الصبر', 'صبر', 'التوبة', 'توبة', 'الحياء',
      'التواضع', 'حقوق الزوجة', 'حقوق الزوج',
    ],
    'الأذكار والدعاء': [
      'الذكر', 'ذكر', 'الأذكار', 'اذكار', 'الذكر', 'الدعاء', 'دعاء',
      'أذكار الصباح', 'أذكار المساء', 'الاستغفار', 'استغفار',
    ],
    'رمضان': [
      'رمضان', 'الصيام', 'صيام', 'قيام رمضان', 'التراويح', 'زكاة الفطر',
      'ليلة القدر', 'ليلة القدر', 'رمضانية',
    ],
  };

  static const _generalKeywords = <String>[
    'اسلام', 'إسلام', 'اسلامي', 'إسلامي', 'دين', 'ديني', 'محاضرة',
    'محاضرات', 'درس', 'دروس', 'خطبة', 'خطب', 'شيخ', 'الشيخ', 'مسجد',
    'المسجد', 'عبادة', 'العبادة', 'جنة', 'الجنة', 'نار', 'النار',
    'قيامة', 'القيامة', 'آخرة', 'اخرة', 'الآخرة', 'وعظ', 'واعظ',
    'داعية', 'قرآن كريم',
  ];

  static const _blockedTerms = <String>[
    'مذاكرة', 'مذكره', 'مذكرة', 'امتحان', 'اختبار', 'مدرسة', 'مدرس',
    'مدرسين', 'واجب', 'منهج', 'طلاب', 'شرح المنهج', 'حل اسئلة',
    'حل أسئلة', 'التربية الدينية', 'الدراسات', 'الرياضيات', 'الفيزياء',
    'الكيمياء', 'اللغة العربية', 'الانجليزي', 'الإنجليزي',
  ];

  static String _normalize(String input) {
    var value = input.trim();
    value = value.replaceAll(RegExp(r'[\u064B-\u0652\u0640]'), '');
    value = value
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ة', 'ه');
    return value.replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
  }

  static List<String> _keywordsForCategory(String category) {
    final exact = _categories[category];
    if (exact != null) return exact;

    final normalizedCategory = _normalize(category);
    for (final entry in _categories.entries) {
      if (_normalize(entry.key) == normalizedCategory) return entry.value;
    }
    return const [];
  }

  static bool _containsAny(String haystack, Iterable<String> keywords) {
    for (final keyword in keywords) {
      final normalized = _normalize(keyword);
      if (normalized.isNotEmpty && haystack.contains(normalized)) return true;
    }
    return false;
  }

  static Set<String> queryCategories(String rawQuery) {
    final query = _normalize(rawQuery);
    if (query.isEmpty) return const {};

    final matches = <String>{};
    for (final entry in _categories.entries) {
      if (_containsAny(query, entry.value)) matches.add(entry.key);
    }
    return matches;
  }

  static String? queryCategory(String rawQuery) {
    final matches = queryCategories(rawQuery);
    return matches.length == 1 ? matches.first : null;
  }

  /// Permissive category validation.
  ///
  /// We do NOT require the user's query to contain one of our predefined
  /// category keywords. Real searches such as "ابن كثير", "الشفاعة",
  /// "أسباب النزول" or a sheikh's name must be allowed naturally.
  ///
  /// We only stop a query when it is clearly asking for another category.
  /// Unknown terms are allowed to reach YouTube and are filtered by result
  /// relevance in the repository.
  static bool isQueryAllowedInCategory({
    required String category,
    required String query,
  }) {
    final normalizedQuery = _normalize(query);
    final normalizedCategory = _normalize(category);

    if (normalizedQuery.isEmpty) return true;

    // Explicitly blocked non-religious/education-only terms.
    if (_containsAny(normalizedQuery, _blockedTerms)) return false;

    final detectedCategories = queryCategories(normalizedQuery);

    // If the query explicitly names another category, reject it. Do not
    // reject unknown terms: natural language searches are much broader than
    // a fixed keyword list.
    if (detectedCategories.isNotEmpty &&
        !detectedCategories.any(
          (item) => _normalize(item) == normalizedCategory,
        )) {
      return false;
    }

    return true;
  }

  static bool isIslamicQuery(String rawQuery) {
    final normalizedQuery = _normalize(rawQuery);
    if (normalizedQuery.isEmpty) return false;
    if (_containsAny(normalizedQuery, _blockedTerms)) return false;

    for (final entry in _categories.entries) {
      if (_containsAny(normalizedQuery, entry.value)) return true;
    }
    return _containsAny(normalizedQuery, _generalKeywords);
  }

  static String enrichQuery(String rawQuery) {
    return '${rawQuery.trim()} محاضرة درس إسلامي';
  }

  static String enrichCategoryQuery({
    required String category,
    required String query,
  }) {
    // Put the category first so YouTube gets a strong topical signal.
    return '${category.trim()} ${query.trim()} محاضرة درس إسلامي';
  }

  static bool isRelevantResult({
    required String title,
    required String description,
    required String channelName,
  }) {
    final haystack = _normalize('$title $description $channelName');
    return _containsAny(haystack, [
      ..._categories.values.expand((x) => x),
      ..._generalKeywords,
    ]);
  }

  static bool isRelevantResultForCategory({
    required String category,
    required String title,
    required String description,
    required String channelName,
    String query = '',
  }) {
    final categoryKeywords = _keywordsForCategory(category);
    final titleText = _normalize(title);
    final channelText = _normalize(channelName);
    final descriptionText = _normalize(description);
    final fullText = '$titleText $descriptionText $channelText';

    final islamicContext = _containsAny(fullText, [
      ..._categories.values.expand((x) => x),
      ..._generalKeywords,
    ]);

    if (!islamicContext) return false;

    // A user's free-form query does not have to match our category dictionary.
    // If it does match the result, that is a strong relevance signal.
    final queryText = _normalize(query);
    if (queryText.isNotEmpty) {
      final queryTokens = queryText
          .split(RegExp(r'\s+'))
          .where((token) => token.length >= 2)
          .toSet();

      final titleAndChannel = '$titleText $channelText';
      final descriptionOnly = descriptionText;

      final queryMatchesTitleOrChannel = queryTokens.any(
        (token) => titleAndChannel.contains(token),
      );
      final queryMatchesDescription = queryTokens.any(
        (token) => descriptionOnly.contains(token),
      );

      // A search result must actually relate to what the user typed. This is
      // what prevents an unrelated query such as "كرة القدم" from returning
      // random Islamic-channel videos.
      if (!queryMatchesTitleOrChannel && !queryMatchesDescription) {
        return false;
      }
    }

    // Strong conflicting category signals in the title/channel are rejected.
    // We intentionally do NOT inspect the description here because Islamic
    // lectures naturally mention adjacent subjects in their descriptions.
    final titleAndChannel = '$titleText $channelText';
    for (final entry in _categories.entries) {
      if (_normalize(entry.key) == _normalize(category)) continue;

      if (_containsAny(titleAndChannel, entry.value)) {
        // If the requested category itself is also strongly present, keep it;
        // otherwise the result is more likely to belong to another section.
        if (!_containsAny(titleAndChannel, categoryKeywords)) {
          return false;
        }
      }
    }

    return true;
  }

}
