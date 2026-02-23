import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:hisn_almuslim/core/models/content_item.dart';
import 'package:meta/meta.dart';

part 'azkar_state.dart';

class AzkarCubit extends Cubit<AzkarState> {
  AzkarCubit() : super(AzkarInitial());

  List<Zekr> azkarList = [];

  Future<void> getAzkar() async {
    emit(AzkarLoading());

    try {
      final response = await rootBundle.loadString("assets/json/azkar.json");
      final List results = jsonDecode(response);
      azkarList = results.map((e) => Zekr.fromJson(e)).toList();
      emit(AzkarLoaded(azkarList));
    } catch (e) {
      emit(AzkarError("Error : $e"));
    }
  }
}
