import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:hisn_almuslim/features/jami%20dua/data/models/dua_model.dart';
part 'dead_dua_state.dart';

class DeadDuaCubit extends Cubit<DeadDuaState> {
  DeadDuaCubit() : super(DeadDuaInitial());

  Future<void> loadDuaDead() async {
    try {
      emit(DeadDuaLoading());

      final jsonString = await rootBundle.loadString(
        "assets/json/dead dua.json",
      );

      final data = json.decode(jsonString);

      final duas = (data['duas'] as List? ?? [])
          .map((e) => DuaModel.fromJson(e))
          .toList();

      emit(DeadDuaLoaded(duas));
    } catch (e) {
      emit(DeadDuaError("Error : $e"));
    }
  }
}
