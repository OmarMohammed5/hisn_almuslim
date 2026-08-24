class IslamicSearchValidator {
  const IslamicSearchValidator._();

  static const Map<String, List<String>>
  _categories = {
    'quran': [
      'قرآن',
      'القرآن',
      'تفسير',
      'سورة',
      'آية',
      'ايات',
      'آيات',
      'تدبر',
      'تلاوة',
      'تجويد',
      'حفظ القرآن',
    ],
    'hadith': [
      'حديث',
      'أحاديث',
      'السنة',
      'سنة',
      'البخاري',
      'بخاري',
      'مسلم',
      'الترمذي',
      'ترمذي',
      'النسائي',
      'نسائي',
      'أبو داود',
      'ابو داود',
      'ابن ماجه',
      'شرح الحديث',
      'الأربعين النووية',
      'الاربعين النووية',
    ],
    'fiqh': [
      'فقه',
      'صلاة',
      'الصلاة',
      'صيام',
      'الصيام',
      'صوم',
      'زكاة',
      'الزكاة',
      'حج',
      'الحج',
      'عمرة',
      'العمرة',
      'وضوء',
      'الوضوء',
      'طهارة',
      'حلال',
      'حرام',
      'أحكام',
      'احكام',
      'فتوى',
      'فتاوى',
    ],
    'aqeedah': [
      'عقيدة',
      'العقيدة',
      'توحيد',
      'التوحيد',
      'ايمان',
      'إيمان',
      'شرك',
      'الأسماء والصفات',
      'الاسماء والصفات',
      'الولاء والبراء',
    ],
    'seerah': [
      'السيرة',
      'سيرة',
      'النبي',
      'الرسول',
      'الصحابة',
      'صحابة',
      'غزوة',
      'غزوات',
      'الهجرة',
      'هجرة',
      'الخلفاء الراشدين',
    ],
    'manners': [
      'أخلاق',
      'اخلاق',
      'آداب',
      'اداب',
      'بر الوالدين',
      'الوالدين',
      'صلة الرحم',
      'الصبر',
      'صبر',
      'التوبة',
      'توبة',
      'الذكر',
      'ذكر',
      'الدعاء',
      'دعاء',
      'الحياء',
      'التواضع',
      'حقوق الزوجة',
      'حقوق الزوج',
    ],
    'prophets': [
      'الأنبياء',
      'أنبياء',
      'الانبياء',
      'قصص الأنبياء',
      'قصص الانبياء',
      'آدم',
      'ادم',
      'نوح',
      'إبراهيم',
      'ابراهيم',
      'موسى',
      'عيسى',
      'يوسف',
      'يونس',
      'يعقوب',
      'اسماعيل',
      'إسماعيل',
      'قصص القرآن',
    ],
    'general': [
      'اسلام',
      'إسلام',
      'اسلامي',
      'إسلامي',
      'دين',
      'ديني',
      'محاضرة',
      'محاضرات',
      'درس',
      'دروس',
      'خطبة',
      'خطب',
      'شيخ',
      'الشيخ',
      'رمضان',
      'مسجد',
      'المسجد',
      'عبادة',
      'العبادة',
      'جنة',
      'الجنة',
      'نار',
      'النار',
      'قيامة',
      'القيامة',
      'آخرة',
      'اخرة',
      'الآخرة',
      'وعظ',
      'واعظ',
      'داعية',
      'قرآن كريم',
    ],
  };

  static const _blockedTerms = <String>[
    'مذاكرة',
    'مذكره',
    'مذكرة',
    'امتحان',
    'اختبار',
    'مدرسة',
    'مدرس',
    'مدرسين',
    'واجب',
    'منهج',
    'طلاب',
    'شرح المنهج',
    'حل اسئلة',
    'حل أسئلة',
    'التربية الدينية',
    'الدراسات',
    'الرياضيات',
    'الفيزياء',
    'الكيمياء',
    'اللغة العربية',
    'الانجليزي',
    'الإنجليزي',
  ];

  static final List<String> _allKeywords =
  _categories.values
      .expand((k) => k)
      .toList(growable: false);

  static String _normalize(String input) {
    var value = input.trim();

    value = value.replaceAll(
      RegExp(r'[\u064B-\u0652\u0640]'),
      '',
    );

    value = value
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ة', 'ه');

    value = value.replaceAll(
      RegExp(r'\s+'),
      ' ',
    );

    return value.toLowerCase();
  }

  static bool isIslamicQuery(
      String rawQuery,
      ) {
    final normalizedQuery =
    _normalize(rawQuery);

    if (normalizedQuery.isEmpty) {
      return false;
    }

    for (final blocked in _blockedTerms) {
      if (normalizedQuery.contains(
        _normalize(blocked),
      )) {
        return false;
      }
    }

    for (final keyword in _allKeywords) {
      final normalizedKeyword =
      _normalize(keyword);

      if (normalizedQuery.contains(
        normalizedKeyword,
      ) ||
          normalizedKeyword.contains(
            normalizedQuery,
          )) {
        return true;
      }
    }

    return false;
  }

  static String enrichQuery(
      String rawQuery,
      ) {
    final trimmed = rawQuery.trim();

    return '$trimmed محاضرة درس إسلامي';
  }

  static bool isRelevantResult({
    required String title,
    required String description,
    required String channelName,
  }) {
    final haystack = _normalize(
      '$title $description $channelName',
    );

    for (final keyword in _allKeywords) {
      if (haystack.contains(
        _normalize(keyword),
      )) {
        return true;
      }
    }

    return false;
  }
}
