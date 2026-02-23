import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hisn_almuslim/features/asma%20allah/data/model/asma_allah_model.dart';

class AsmaRepository {
  Future<List<AsmaAllahModel>> loadNames() async {
    final String response = await rootBundle.loadString(
      'assets/json/allah_names_ar.json',
    );

    final List data = json.decode(response);

    return data.map((e) => AsmaAllahModel.fromJson(e)).toList();
  }
}
