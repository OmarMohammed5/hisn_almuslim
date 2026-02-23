import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:hisn_almuslim/features/jami%20dua/data/models/dua_chapter.dart';
part 'dua_state.dart';

class DuaCubit extends Cubit<DuaState> {
  DuaCubit() : super(DuaInitial());

  Future<void> loadDua() async {
    try {
      emit(DuaLoading());

      final jsonString = await rootBundle.loadString(
        "assets/json/jami_dua.json",
      );

      final data = json.decode(jsonString);

      final duas = (data['chapters'] as List)
          .map((e) => DuaChapter.fromJson(e))
          .toList();
      emit(DuaLoaded(duas));
    } catch (e) {
      emit(DuaError("Error : ${e.toString()}"));
    }
  }
}
