import 'jami_dua_category.dart';

class JamiDuaCategoryDefinition {
  final JamiDuaCategoryType type;
  final String title;
  final String shareCategory;

  const JamiDuaCategoryDefinition({
    required this.type,
    required this.title,
    required this.shareCategory,
  });
}

class JamiDuaCategoryFactory {
  JamiDuaCategoryFactory._();

  static const definitions = <JamiDuaCategoryDefinition>[
    JamiDuaCategoryDefinition(
      type: JamiDuaCategoryType.etiquette,
      title: 'آداب الدعاء',
      shareCategory: 'آداب الدعاء',
    ),
    JamiDuaCategoryDefinition(
      type: JamiDuaCategoryType.quran,
      title: 'أدعية من القرآن',
      shareCategory: 'أدعية من القرآن',
    ),
    JamiDuaCategoryDefinition(
      type: JamiDuaCategoryType.sunnah,
      title: 'أدعية من السنة',
      shareCategory: 'أدعية من السنة',
    ),
    JamiDuaCategoryDefinition(
      type: JamiDuaCategoryType.hajjAndOmra,
      title: 'أدعية الحج و العمرة',
      shareCategory: 'أدعية الحج و العمرة',
    ),
    JamiDuaCategoryDefinition(
      type: JamiDuaCategoryType.deceased,
      title: 'أدعية للمتوفي',
      shareCategory: 'دعاء للمتوفي',
    ),
    JamiDuaCategoryDefinition(
      type: JamiDuaCategoryType.lastTen,
      title: 'أدعية العشر الأواخر',
      shareCategory: 'أدعية العشر الأواخر',
    ),
  ];

  static JamiDuaCategoryDefinition getDefinition(
    JamiDuaCategoryType type,
  ) {
    return definitions.firstWhere((definition) => definition.type == type);
  }
}