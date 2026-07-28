import 'package:equatable/equatable.dart';
import 'package:hisn_almuslim/features/quran_audio/data/models/reciter_name_model.dart';
import 'package:hisn_almuslim/features/quran_audio/data/models/rewaya_model.dart';

class ReciterModel extends Equatable {
  final int id;
  final ReciterNameModel reciter;
  final RewayaModel rewaya;
  final String server;
  final String? link;

  const ReciterModel({
    required this.id,
    required this.reciter,
    required this.rewaya,
    required this.server,
    this.link,
  });

  factory ReciterModel.fromJson(Map<String, dynamic> json) {
    return ReciterModel(
      id: json['id'] as int,
      reciter: ReciterNameModel.fromJson(
        json['reciter'] as Map<String, dynamic>,
      ),
      rewaya: RewayaModel.fromJson(json['rewaya'] as Map<String, dynamic>),
      server: json['server'] as String,
      link: json['link'] as String?,
    );
  }

  /// Converts ReciterModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reciter': reciter.toJson(),
      'rewaya': rewaya.toJson(),
      'server': server,
      'link': link,
    };
  }

  @override
  List<Object?> get props => [id, reciter, rewaya, server, link];
}
