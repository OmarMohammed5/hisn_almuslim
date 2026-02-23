import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hisn_almuslim/features/hadith/books/bukhary/data/models/chapter.dart';

part 'chapters_state.dart';

class ChaptersCubit extends Cubit<ChaptersState> {
  ChaptersCubit() : super(ChaptersInitial());

  // Load Chapters of Bukhary hadiths from json
  Future<void> loadChapters() async {
    try {
      emit(ChaptersLoading());

      // Conver json to String and load
      final jsonString = await rootBundle.loadString(
        "assets/json/Sahih_Albukhary.json",
      );

      final chapters = await compute(parseBukharyChapters, jsonString);

      emit(ChaptersLoaded(chapters));
    } catch (e) {
      emit(ChaptersError(e.toString()));
    }
  }
}

List<Chapter> parseBukharyChapters(String jsonString) {
  final data = json.decode(jsonString);
  return (data['chapters'] as List).map((e) => Chapter.fromJson(e)).toList();
}
