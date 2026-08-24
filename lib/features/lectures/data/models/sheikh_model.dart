import '../../domain/entities/sheikh.dart';

class SheikhModel extends Sheikh {
  const SheikhModel({
    required super.id,
    required super.name,
    required super.channelId,
    required super.thumbnailUrl,
    required super.subscriberCount,
    required super.videoCount,
  });

  factory SheikhModel.fromJson(Map<String, dynamic> json) {
    return SheikhModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      channelId: json['channelId'] as String? ?? '',
      thumbnailUrl: json['thumbnailUrl'] as String? ?? '',
      subscriberCount:
      (json['subscriberCount'] as num?)?.toInt() ?? 0,
      videoCount:
      (json['videoCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'channelId': channelId,
      'thumbnailUrl': thumbnailUrl,
      'subscriberCount': subscriberCount,
      'videoCount': videoCount,
    };
  }
}
