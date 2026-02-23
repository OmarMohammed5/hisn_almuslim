import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:hisn_almuslim/features/jami%20dua/data/models/etiquette_item.dart';
part 'etiquette_dua_state.dart';

class EtiquetteDuaCubit extends Cubit<EtiquetteDuaState> {
  EtiquetteDuaCubit() : super(EtiquetteDuaInitial());

  Future<void> loadEtiquetteDua() async {
    try {
      emit(EtiquetteDuaLoading());
      final jsonString = await rootBundle.loadString(
        "assets/json/jami_dua.json",
      );

      final data = json.decode(jsonString);

      final items = (data['etiquette_of_dua']['items'] as List)
          .map((e) => EtiquetteItem.fromJson(e))
          .toList();

      emit(EtiquetteDuaLoaded(items));
    } catch (e) {
      emit(EtiquetteDuaError("Error : ${e.toString()}"));
    }
  }
}
