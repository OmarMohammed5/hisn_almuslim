import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hisn_almuslim/features/hadith/books/muslim/data/model/chapter_sahih_muslim.dart';

part 'sahih_muslim_state.dart';

class SahihMuslimCubit extends Cubit<SahihMuslimState> {
  SahihMuslimCubit() : super(SahihMuslimInitial());

  Future<void> loadSahihMuslim() async {
    try {
      emit(SahihMuslimLoading());
      final jsonString = await rootBundle.loadString(
        "assets/json/Sahih Muslim.json",
      );

      final chapters = await compute(parseMuslimChapters, jsonString);
      emit(SahihMuslimLoaded(chapters));
    } catch (e) {
      emit(SahihMuslimError(e.toString()));
    }
  }
}

List<ChapterSahihMuslim> parseMuslimChapters(String jsonString) {
  final data = json.decode(jsonString);
  return (data['chapters'] as List)
      .map((e) => ChapterSahihMuslim.fromJson(e))
      .toList();
}
