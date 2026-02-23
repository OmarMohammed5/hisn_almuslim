import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hisn_almuslim/features/hadith/books/nawawi/data/model/hadith.dart';
import 'package:hisn_almuslim/features/hadith/books/nawawi/data/model/hadith_response.dart';
part 'hadith_state.dart';

class HadithCubit extends Cubit<HadithState> {
  HadithCubit() : super(HadithInitial());
  Future<void> loadHadiths() async {
    emit(HadithLoading());
    try {
      final response = await rootBundle.loadString("assets/hadith.json");

      final hadiths = await compute(parseHadith, response);

      emit(HadithLoaded(hadiths));
    } catch (e) {
      emit(HadithError("$e Failed to load hadiths"));
    }
  }
}

List<Hadith> parseHadith(String response) {
  debugPrint(response);
  final decodeResponse = jsonDecode(response);
  final hadithResponse = HadithResponse.fromJson(decodeResponse);
  return hadithResponse.hadithList;
}
