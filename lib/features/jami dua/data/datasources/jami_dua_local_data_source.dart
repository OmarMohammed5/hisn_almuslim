import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/entities/jami_dua_category.dart';
import '../../domain/entities/jami_dua_category_factory.dart';

abstract class JamiDuaLocalDataSource {
  Future<JamiDuaCategory> getCategory(JamiDuaCategoryType type);
}

class JamiDuaLocalDataSourceImpl implements JamiDuaLocalDataSource {
  const JamiDuaLocalDataSourceImpl();

  @override
  Future<JamiDuaCategory> getCategory(JamiDuaCategoryType type) async {
    switch (type) {
      case JamiDuaCategoryType.etiquette:
        return _loadEtiquette();

      case JamiDuaCategoryType.quran:
        return _loadQuranOrSunnah(
          type: type,
          chapterId: 1,
        );

      case JamiDuaCategoryType.sunnah:
        return _loadQuranOrSunnah(
          type: type,
          chapterId: 2,
        );

      case JamiDuaCategoryType.hajjAndOmra:
        return _loadHajjAndOmra();

      case JamiDuaCategoryType.deceased:
        return _loadSimpleDuas(
          type: type,
          assetPath: 'assets/json/dead dua.json',
        );

      case JamiDuaCategoryType.lastTen:
        return _loadSimpleDuas(
          type: type,
          assetPath: 'assets/json/The Last Ten Dua.json',
        );
    }
  }

  Future<JamiDuaCategory> _loadEtiquette() async {
    final definition = JamiDuaCategoryFactory.getDefinition(
      JamiDuaCategoryType.etiquette,
    );
    final data = await _loadJson('assets/json/jami_dua.json');
    final rawItems =
        (data['etiquette_of_dua']?['items'] as List? ?? const []);

    final items = rawItems.map((raw) {
      final json = Map<String, dynamic>.from(raw as Map);
      return JamiDuaItem(
        id: _intValue(json['id']),
        type: JamiDuaContentType.etiquette,
        content: _stringValue(json['arabic']),
        reference: _stringValue(json['reference']),
        hadithText: _stringValue(json['hadith_text']),
      );
    }).toList();

    return JamiDuaCategory(
      type: JamiDuaCategoryType.etiquette,
      title: definition.title,
      shareCategory: definition.shareCategory,
      sections: [
        JamiDuaSection(id: 1, title: 'آداب الدعاء', items: items),
      ],
    );
  }

  Future<JamiDuaCategory> _loadQuranOrSunnah({
    required JamiDuaCategoryType type,
    required int chapterId,
  }) async {
    final definition = JamiDuaCategoryFactory.getDefinition(type);
    final data = await _loadJson('assets/json/jami_dua.json');
    final chapters = (data['chapters'] as List? ?? const [])
        .map((raw) => Map<String, dynamic>.from(raw as Map))
        .toList();

    final chapter = chapters.firstWhere(
      (item) => _intValue(item['chapter_id']) == chapterId,
    );

    final rawDuas = (chapter['duas'] as List? ?? const []);
    final items = rawDuas.map((raw) {
      final json = Map<String, dynamic>.from(raw as Map);
      return JamiDuaItem(
        id: _intValue(json['dua_id']),
        type: JamiDuaContentType.dua,
        content: _stringValue(json['arabic']),
        reference: _stringValue(json['reference']),
      );
    }).toList();

    return JamiDuaCategory(
      type: type,
      title: definition.title,
      shareCategory: definition.shareCategory,
      sections: [
        JamiDuaSection(
          id: chapterId,
          title: _stringValue(chapter['chapter_title']),
          items: items,
        ),
      ],
    );
  }

  Future<JamiDuaCategory> _loadHajjAndOmra() async {
    final definition = JamiDuaCategoryFactory.getDefinition(
      JamiDuaCategoryType.hajjAndOmra,
    );
    final data = await _loadJson('assets/json/Hajj and Omra Dua.json');
    final chapters = (data['chapters'] as List? ?? const []);

    final sections = chapters.map((raw) {
      final json = Map<String, dynamic>.from(raw as Map);
      final rawItems = (json['items'] as List? ?? const []);

      final items = rawItems.map((item) {
        final itemJson = Map<String, dynamic>.from(item as Map);
        return JamiDuaItem(
          id: _intValue(itemJson['id']),
          type: JamiDuaContentType.dua,
          title: _stringValue(itemJson['title']),
          content: _stringValue(itemJson['text']),
        );
      }).toList();

      return JamiDuaSection(
        id: _intValue(json['chapter_id']),
        title: _stringValue(json['chapter_title']),
        items: items,
      );
    }).toList();

    return JamiDuaCategory(
      type: JamiDuaCategoryType.hajjAndOmra,
      title: definition.title,
      shareCategory: definition.shareCategory,
      sections: sections,
    );
  }

  Future<JamiDuaCategory> _loadSimpleDuas({
    required JamiDuaCategoryType type,
    required String assetPath,
  }) async {
    final definition = JamiDuaCategoryFactory.getDefinition(type);
    final data = await _loadJson(assetPath);
    final rawDuas = (data['duas'] as List? ?? const []);

    final items = rawDuas.map((raw) {
      final json = Map<String, dynamic>.from(raw as Map);
      return JamiDuaItem(
        id: _intValue(json['id']),
        type: JamiDuaContentType.dua,
        content: _stringValue(json['content']),
      );
    }).toList();

    return JamiDuaCategory(
      type: type,
      title: definition.title,
      shareCategory: definition.shareCategory,
      sections: [
        JamiDuaSection(id: 1, title: definition.title, items: items),
      ],
    );
  }

  Future<Map<String, dynamic>> _loadJson(String assetPath) async {
    final jsonString = await rootBundle.loadString(assetPath);
    return Map<String, dynamic>.from(json.decode(jsonString) as Map);
  }

  static int _intValue(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _stringValue(dynamic value) {
    return value?.toString() ?? ' ';
  }
}