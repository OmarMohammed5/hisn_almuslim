import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:hisn_almuslim/features/jami%20dua/data/models/hajj_chapter.dart';
part 'hajj_dua_state.dart';

class HajjDuaCubit extends Cubit<HajjDuaState> {
  HajjDuaCubit() : super(HajjDuaInitial());

  Future<void> loadHajjDua() async {
    try {
      emit(HajjDuaLoading());

      final jsonString = await rootBundle.loadString(
        "assets/json/Hajj and Omra Dua.json",
      );

      final data = json.decode(jsonString);

      final items = (data['chapters'] as List? ?? [])
          .map((e) => HajjChapter.fromJson(e))
          .toList();

      emit(HajjDuaLoaded(items));
    } catch (e) {
      emit(HajjDuaError("Error : $e"));
    }
  }
}
