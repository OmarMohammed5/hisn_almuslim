// lib/features/quran/data/models/quran_response_model.dart

import 'package:equatable/equatable.dart';
import 'quran_data_model.dart';

class QuranResponseModel extends Equatable {
  final int code;
  final String status;
  final QuranDataModel data;

  const QuranResponseModel({
    required this.code,
    required this.status,
    required this.data,
  });

  factory QuranResponseModel.fromJson(Map<String, dynamic> json) {
    return QuranResponseModel(
      code: json['code'] as int? ?? 200,
      status: json['status'] as String? ?? 'OK',
      data: QuranDataModel.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'status': status,
      'data': data.toJson(),
    };
  }

  @override
  List<Object?> get props => [code, status, data];
}