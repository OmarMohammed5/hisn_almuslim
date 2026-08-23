import 'package:equatable/equatable.dart';

class RadioStation extends Equatable {
  final String id;
  final String name;
  final String streamUrl;
  final String? imageUrl;

  const RadioStation({
    required this.id,
    required this.name,
    required this.streamUrl,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    streamUrl,
    imageUrl,
  ];
}