class LectureProgress {
  final String lectureId;
  final Duration position;
  final Duration duration;
  final DateTime lastPlayedAt;
  final bool completed;

  const LectureProgress({
    required this.lectureId,
    required this.position,
    required this.duration,
    required this.lastPlayedAt,
    required this.completed,
  });

  double get percentage {
    if (duration.inMilliseconds <= 0) return 0;

    final value =
        position.inMilliseconds / duration.inMilliseconds;

    return value.clamp(0.0, 1.0);
  }
}
