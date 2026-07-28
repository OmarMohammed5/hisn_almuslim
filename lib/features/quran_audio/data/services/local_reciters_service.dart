// features/quran_audio/data/services/local_reciters_service.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/reciter_model.dart';

/// Service responsible for loading reciters data from local JSON asset
class LocalRecitersService {
  static const String _recitersAssetPath = 'assets/json/audio_surah.json';

  Future<List<ReciterModel>> loadReciters() async {
    try {
      // Load the JSON string from assets
      final String jsonString = await rootBundle.loadString(_recitersAssetPath);

      // Parse the JSON string
      final List<dynamic> jsonList = json.decode(jsonString);

      // Convert each JSON object to ReciterModel
      final List<ReciterModel> reciters = jsonList
          .map((json) => ReciterModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return reciters;
    } catch (e) {
      throw Exception('Failed to load reciters: $e');
    }
  }

  List<ReciterModel> loadRecitersSync() {
    try {
      throw UnsupportedError(
        'Use loadReciters() async instead. Synchronous loading is not supported.',
      );
    } catch (e) {
      rethrow;
    }
  }
}
