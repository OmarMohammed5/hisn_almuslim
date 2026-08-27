import 'level_entity.dart';

class TopicEntity {
  final String name;
  final String slug;
  final List<LevelEntity> levels;

  const TopicEntity({
    required this.name,
    required this.slug,
    required this.levels,
  });
}