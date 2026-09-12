enum HadithBookType {
  bukhary,
  muslim,
  riyadAlSaliheen,
  nawawi,
}

class HadithBook {
  final HadithBookType type;
  final String title;
  final String subtitle;
  final String number;
  final String assetPath;
  final String shareCategory;
  final String indexHint;

  const HadithBook({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.number,
    required this.assetPath,
    required this.shareCategory,
    required this.indexHint,
  });

  static const bukhary = HadithBook(
    type: HadithBookType.bukhary,
    title: 'صحيح البخاري',
    subtitle: 'متابعة القراءة من\nالحديث',
    number: '١',
    assetPath: 'assets/json/Sahih_Albukhary.json',
    shareCategory: 'صحيح البخاري',
    indexHint: 'ابحث في الأبواب ...',
  );

  static const muslim = HadithBook(
    type: HadithBookType.muslim,
    title: 'صحيح مسلم',
    subtitle: 'متابعة القراءة من\nالحديث',
    number: '١',
    assetPath: 'assets/json/Sahih Muslim.json',
    shareCategory: 'صحيح مسلم',
    indexHint: 'ابحث في الأبواب ...',
  );

  static const riyadAlSaliheen = HadithBook(
    type: HadithBookType.riyadAlSaliheen,
    title: 'رياض الصالحين',
    subtitle: 'متابعة القراءة من\nالحديث',
    number: '١',
    assetPath: 'assets/json/Reyad al-Salehin.json',
    shareCategory: 'رياض الصالحين',
    indexHint: 'ابحث في الأبواب ...',
  );

  static const nawawi = HadithBook(
    type: HadithBookType.nawawi,
    title: 'الأربعون النووية',
    subtitle: 'متابعة القراءة من\nالحديث',
    number: '١',
    assetPath: 'assets/hadith.json',
    shareCategory: 'الأربعون النووية',
    indexHint: 'ابحث عن حديث ...',
  );

  String errorMessage(Object error) {
    if (type == HadithBookType.nawawi) {
      return '$error Failed to load hadiths';
    }
    return error.toString();
  }

  static HadithBook fromType(HadithBookType type) {
    switch (type) {
      case HadithBookType.bukhary:
        return bukhary;
      case HadithBookType.muslim:
        return muslim;
      case HadithBookType.riyadAlSaliheen:
        return riyadAlSaliheen;
      case HadithBookType.nawawi:
        return nawawi;
    }
  }
}
