import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/prophet_story_model.dart';

abstract class StoriesLocalDataSource {
  Future<List<ProphetStoryModel>> getStories();
}

class StoriesLocalDataSourceImpl implements StoriesLocalDataSource {
  final String _assetPath;

  StoriesLocalDataSourceImpl({String assetPath = 'assets/json/stories.json'})
      : _assetPath = assetPath;
  
  @override
  Future<List<ProphetStoryModel>> getStories() async {
    try {
      final String jsonString = await rootBundle.loadString(_assetPath);
      final List<dynamic> jsonList = json.decode(jsonString);

      return jsonList
          .map((e) => ProphetStoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}