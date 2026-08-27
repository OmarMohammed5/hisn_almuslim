import 'package:hisn_almuslim/features/islamic_quiz/domain/entities/main_category_entity.dart';

import 'topic_model.dart';

class MainCategoryModel {
  final int id;
  final String arabicName;
  final String englishName;
  final String description;
  final String icon;
  final List<TopicModel> topics;

  const MainCategoryModel({
    required this.id,
    required this.arabicName,
    required this.englishName,
    required this.description,
    required this.icon,
    required this.topics,
  });

  factory MainCategoryModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return MainCategoryModel(
      id: json['id'] as int,
      arabicName: json['arabicName'] as String,
      englishName: json['englishName'] as String,
      description: json['description'] as String,
      icon: json['icons'] as String,
      topics: (json['topics'] as List)
          .map(
            (topic) => TopicModel.fromJson(
          topic as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }

  MainCategoryEntity toEntity(){
    return MainCategoryEntity(
        id: id,
        arabicName: arabicName,
        englishName: englishName,
        description: description,
        icon: icon,
        topics: topics.map((topic) => topic.toEntity()).toList(),
    );
  }
}