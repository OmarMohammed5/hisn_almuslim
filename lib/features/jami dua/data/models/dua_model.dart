class DuaModel {
  final int id;
  final String content;

  DuaModel({required this.id, required this.content});

  factory DuaModel.fromJson(Map<String, dynamic> json) {
    return DuaModel(id: json['id'] ?? 0, content: json['content'] ?? " ");
  }
}
