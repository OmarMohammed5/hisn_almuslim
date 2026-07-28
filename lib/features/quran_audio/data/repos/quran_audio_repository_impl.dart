import 'package:hisn_almuslim/features/quran_audio/data/repos/quran_audio_repository.dart';

import '../services/local_reciters_service.dart';
import '../models/reciter_model.dart';

class QuranAudioRepositoryImpl implements QuranAudioRepository {
  final LocalRecitersService _localRecitersService;

  QuranAudioRepositoryImpl({LocalRecitersService? localRecitersService})
    : _localRecitersService = localRecitersService ?? LocalRecitersService();

  @override
  Future<List<ReciterModel>> getReciters() async {
    try {
      return await _localRecitersService.loadReciters();
    } catch (e) {
      throw Exception('Failed to get reciters from repository: $e');
    }
  }
}
