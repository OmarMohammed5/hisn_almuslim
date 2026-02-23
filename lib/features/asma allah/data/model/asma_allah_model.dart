class AsmaAllahModel {
  final int id;
  final String name;
  final String text;

  AsmaAllahModel({required this.id, required this.name, required this.text});

  factory AsmaAllahModel.fromJson(Map<String, dynamic> json) {
    return AsmaAllahModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      text: json['text'] ?? "",
    );
  }
}
