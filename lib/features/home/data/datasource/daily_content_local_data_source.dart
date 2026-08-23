import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/daily_content_model.dart';

class DailyContentLocalDataSource {
  static const String _jsonPath =
      'assets/json/daily_content.json';

  Future<Map<String, List<DailyContentModel>>> loadContent() async {
    final jsonString = await rootBundle.loadString(
      _jsonPath,
    );

    final Map<String, dynamic> json =
    jsonDecode(jsonString);

    return {
      'ayah': _parseList(json['ayah']),
      'hadith': _parseList(json['hadith']),
      'dhikr': _parseList(json['dhikr']),
      'dua': _parseList(json['dua']),
    };
  }

  List<DailyContentModel> _parseList(
      dynamic data,
      ) {
    if (data is! List) {
      return [];
    }

    return data
        .map(
          (item) => DailyContentModel.fromJson(
        item as Map<String, dynamic>,
      ),
    )
        .toList();
  }
}