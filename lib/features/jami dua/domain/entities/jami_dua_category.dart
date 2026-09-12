enum JamiDuaCategoryType {
  etiquette,
  quran,
  sunnah,
  hajjAndOmra,
  deceased,
  lastTen,
}

enum JamiDuaContentType {
  dua,
  etiquette,
}

class JamiDuaCategory {
  final JamiDuaCategoryType type;
  final String title;
  final String shareCategory;
  final List<JamiDuaSection> sections;

  const JamiDuaCategory({
    required this.type,
    required this.title,
    required this.shareCategory,
    required this.sections,
  });

  bool get hasTabs => sections.length > 1;
}

class JamiDuaSection {
  final int id;
  final String title;
  final List<JamiDuaItem> items;

  const JamiDuaSection({
    required this.id,
    required this.title,
    required this.items,
  });
}

class JamiDuaItem {
  final int id;
  final JamiDuaContentType type;
  final String content;
  final String? title;
  final String? reference;
  final String hadithText;

  const JamiDuaItem({
    required this.id,
    required this.type,
    required this.content,
    this.title,
    this.reference,
    this.hadithText = '',
  });

  bool get isEtiquette => type == JamiDuaContentType.etiquette;
}