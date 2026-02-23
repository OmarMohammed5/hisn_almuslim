import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hisn_almuslim/features/hadith/books/reyad%20al%20salehin/data/model/chapter_reyad_al_saliheen.dart';

part 'reyad_al_saliheen_state.dart';

class ReyadAlSaliheenCubit extends Cubit<ReyadAlSaliheenState> {
  ReyadAlSaliheenCubit() : super(ReyadAlSaliheenInitial());

  Future<void> loadReyadAlSaliheen() async {
    try {
      emit(ReyadAlSaliheenLoading());

      final jsonString = await rootBundle.loadString(
        "assets/json/Reyad al-Salehin.json",
      );

      final chapters = await compute(parseReyad, jsonString);
      emit(ReyadAlSaliheenLoaded(chapters));
    } catch (e) {
      emit(ReyadAlSaliheenError(e.toString()));
    }
  }
}

List<ChapterReyadAlSaliheen> parseReyad(String jsonString) {
  final data = json.decode(jsonString);
  return (data['chapters'] as List)
      .map((e) => ChapterReyadAlSaliheen.fromJson(e))
      .toList();
}
