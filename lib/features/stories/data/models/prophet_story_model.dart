import 'package:equatable/equatable.dart';
import '../../domain/entities/prophet_story.dart';

class ProphetStoryModel extends Equatable {
  final String prophet;
  final String story;

  const ProphetStoryModel({
    required this.prophet,
    required this.story,
  });

  factory ProphetStoryModel.fromJson(Map<String, dynamic> json) {
    return ProphetStoryModel(
      prophet: json['prophet'] as String? ?? '',
      story: json['story'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prophet': prophet,
      'story': story,
    };
  }

  ProphetStory toDomain() {
    return ProphetStory(
      prophet: prophet,
      story: story,
    );
  }

  @override
  List<Object?> get props => [prophet, story];
}