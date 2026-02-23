class EtiquetteItem {
  final int id;
  final String arabic;
  final String reference;
  final String hadithText;

  EtiquetteItem({
    required this.id,
    required this.arabic,
    required this.reference,
    required this.hadithText,
  });

  factory EtiquetteItem.fromJson(Map<String, dynamic> json) {
    return EtiquetteItem(
      id: json['id'] ?? 0,
      arabic: json['arabic'] ?? " ",
      reference: json['reference'] ?? " ",
      hadithText: json['hadith_text'] ?? " ",
    );
  }
}
