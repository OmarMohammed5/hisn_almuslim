import 'topic_entity.dart';

class MainCategoryEntity {
  final int id;
  final String arabicName;
  final String englishName;
  final String description;
  final String icon;
  final List<TopicEntity> topics;

  const MainCategoryEntity({
    required this.id,
    required this.arabicName,
    required this.englishName,
    required this.description,
    required this.icon,
    required this.topics,
  });
}