import '../../data/models/reciter_model.dart';

abstract class QuranAudioRepository {
  Future<List<ReciterModel>> getReciters();
}
