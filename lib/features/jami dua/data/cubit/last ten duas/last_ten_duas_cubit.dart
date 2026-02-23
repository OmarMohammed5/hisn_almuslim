import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:hisn_almuslim/features/jami%20dua/data/models/dua_model.dart';

part 'last_ten_duas_state.dart';

class LastTenDuasCubit extends Cubit<LastTenDuasState> {
  LastTenDuasCubit() : super(LastTenDuasInitial());

  Future<void> loadLastTenDuas() async {
    try {
      emit(LastTenDuasLoading());

      final jsonString = await rootBundle.loadString(
        "assets/json/The Last Ten Dua.json",
      );

      final data = json.decode(jsonString);

      final duas = (data['duas'] as List? ?? [])
          .map((e) => DuaModel.fromJson(e))
          .toList();

      emit(LastTenDuasLoaded(duas));
    } catch (e) {
      emit(LastTenDuasError("Error : $e"));
    }
  }
}
