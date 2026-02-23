import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hisn_almuslim/features/hadith/books/nawawi/data/model/hadith.dart';
import 'package:hisn_almuslim/features/hadith/books/nawawi/data/model/hadith_response.dart';

class HadithService {
  static Future<List<Hadith>> loadArbaeenHadith() async {
    final String jsonString = await rootBundle.loadString('assets/hadith.json');

    final Map<String, dynamic> jsonData = json.decode(jsonString);

    final response = HadithResponse.fromJson(jsonData);
    return response.hadithList;
  }
}
