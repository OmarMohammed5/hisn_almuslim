import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/services.dart';

import '../models/quiz_database_model.dart';

class QuizLocalDataSource {
  QuizDatabaseModel? _cachedDatabase;

  Future<QuizDatabaseModel> loadQuizDatabase() async {
    if (_cachedDatabase != null) {
      return _cachedDatabase!;
    }

    final jsonString = await rootBundle.loadString(
      'assets/questions/database.json',
    );

    final database = await Isolate.run(() => _parseQuizDatabase(jsonString));

    _cachedDatabase = database;

    return database;
  }
}

QuizDatabaseModel _parseQuizDatabase(String jsonString) {
  final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;

  return QuizDatabaseModel.fromJson(jsonMap);
}
