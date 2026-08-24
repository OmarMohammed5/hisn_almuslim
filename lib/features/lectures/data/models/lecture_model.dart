import '../../domain/entities/lecture.dart';

class LectureModel extends Lecture {
  const LectureModel({
    required super.id,
    required super.title,
    required super.description,
    required super.channelId,
    required super.channelName,
    required super.thumbnailUrl,
    required super.publishedAt,
    required super.duration,
  });

  factory LectureModel.fromJson(Map<String, dynamic> json) {
    return LectureModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      channelId: json['channelId'] as String? ?? '',
      channelName: json['channelName'] as String? ?? '',
      thumbnailUrl: json['thumbnailUrl'] as String? ?? '',
      publishedAt: DateTime.tryParse(
        json['publishedAt'] as String? ?? '',
      ) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      duration: Duration(
        seconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'channelId': channelId,
      'channelName': channelName,
      'thumbnailUrl': thumbnailUrl,
      'publishedAt': publishedAt.toIso8601String(),
      'durationSeconds': duration.inSeconds,
    };
  }
}
