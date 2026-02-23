import 'package:hisn_almuslim/features/jami%20dua/data/models/etiquette_item.dart';

class EtiquetteDua {
  final String title;
  final List<EtiquetteItem> items;

  EtiquetteDua({required this.title, required this.items});

  factory EtiquetteDua.fromJson(Map<String, dynamic> json) {
    return EtiquetteDua(
      title: json['title'] ?? " ",
      items: (json['items'] as List? ?? [])
          .map((e) => EtiquetteItem.fromJson(e))
          .toList(),
    );
  }
}
