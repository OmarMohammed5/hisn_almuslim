class Dua {
  final int duaId;
  final String contentDua;
  final String reference;

  Dua({required this.duaId, required this.contentDua, required this.reference});

  factory Dua.fromJson(Map<String, dynamic> json) {
    return Dua(
      duaId: json['dua_id'] ?? 0,
      contentDua: json['arabic'] ?? " ",
      reference: json['reference'] ?? " ",
    );
  }
}
