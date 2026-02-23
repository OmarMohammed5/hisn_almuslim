import 'package:hisn_almuslim/features/jami%20dua/data/models/dua_model.dart';

class DuaRepo {
  final String title;
  final List<DuaModel> duas;

  DuaRepo({required this.title, required this.duas});

  factory DuaRepo.fromJson(Map<String, dynamic> json) {
    return DuaRepo(
      title: json['title'] ?? " ",
      duas: (json['duas'] as List? ?? [])
          .map((e) => DuaModel.fromJson(e))
          .toList(),
    );
  }
}
