
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../models/quran_response_model.dart';
import 'quran_local_data_source.dart';

class QuranLocalDataSourceImpl implements QuranLocalDataSource {
  static const String _quranAssetPath = 'assets/json/quranV2.json';

  QuranResponseModel? _cachedQuran;
  bool _isLoading = false;

  @override
  Future<QuranResponseModel> loadQuran() async {
    if (_isLoading) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (_cachedQuran != null) {
        return _cachedQuran!;
      }
      await Future.delayed(const Duration(milliseconds: 200));
      if (_cachedQuran != null) {
        return _cachedQuran!;
      }
    }

    _isLoading = true;

    try {
      final String jsonString = await rootBundle.loadString(_quranAssetPath);

      // ====== طباعة الـ JSON للتأكد ======
      print('✅ Quran JSON loaded successfully');
      print('📏 Length: ${jsonString.length} chars');

      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      // ====== طباعة المفاتيح الرئيسية ======
      print('🔑 Keys: ${jsonMap.keys}');

      final quranResponse = QuranResponseModel.fromJson(jsonMap);

      _cachedQuran = quranResponse;

      // ====== طباعة عدد السور ======
      print('📚 Total Surahs: ${quranResponse.data.surahs.length}');

      return quranResponse;
    } catch (e, stackTrace) {
      _cachedQuran = null;
      print('❌ Error loading Quran: $e');
      print('📚 Stack trace: $stackTrace');
      throw Exception('Failed to load Quran data: $e');
    } finally {
      _isLoading = false;
    }
  }

  @override
  Future<QuranResponseModel> getQuran() async {
    if (_cachedQuran != null) {
      return _cachedQuran!;
    }
    return await loadQuran();
  }

  @override
  void clearCache() {
    _cachedQuran = null;
    _isLoading = false;
  }

  @override
  bool isDataCached() {
    return _cachedQuran != null;
  }

  Future<void> preloadQuran() async {
    if (!isDataCached()) {
      await loadQuran();
    }
  }
}