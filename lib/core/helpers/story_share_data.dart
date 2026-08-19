import '../../features/stories/domain/entities/prophet_story.dart';

class StoryShareData {
  final String title;
  final String content;
  final String category;
  final ProphetStory story;
  final int currentIndex;
  final int totalStories;

  const StoryShareData({
    required this.title,
    required this.content,
    required this.category,
    required this.story,
    required this.currentIndex,
    required this.totalStories,
  });
}