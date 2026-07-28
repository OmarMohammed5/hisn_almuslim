import 'package:equatable/equatable.dart';

class ReciterNameModel extends Equatable {
  final String ar;
  final String en;

  const ReciterNameModel({required this.ar, required this.en});

  factory ReciterNameModel.fromJson(Map<String, dynamic> json) {
    return ReciterNameModel(ar: json['ar'] as String, en: json['en'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'ar': ar, 'en': en};
  }

  @override
  List<Object?> get props => [ar, en];
}
