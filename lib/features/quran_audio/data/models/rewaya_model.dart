import 'package:equatable/equatable.dart';

class RewayaModel extends Equatable {
  final String ar;
  final String en;

  const RewayaModel({required this.ar, required this.en});

  factory RewayaModel.fromJson(Map<String, dynamic> json) {
    return RewayaModel(ar: json['ar'] as String, en: json['en'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'ar': ar, 'en': en};
  }

  @override
  List<Object?> get props => [ar, en];
}
