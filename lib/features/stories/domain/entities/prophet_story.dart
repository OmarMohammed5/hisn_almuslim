import 'package:equatable/equatable.dart';

class ProphetStory extends Equatable {
  final String prophet;
  final String story;

  const ProphetStory({
    required this.prophet,
    required this.story,
  });

  @override
  List<Object?> get props => [prophet, story];
}