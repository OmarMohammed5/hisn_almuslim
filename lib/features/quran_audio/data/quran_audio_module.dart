import '../data/services/local_reciters_service.dart';
import '../logic/quran_audio_cubit.dart';
import 'repos/quran_audio_repository.dart';
import 'repos/quran_audio_repository_impl.dart';

/// Temporary module for providing dependencies
///
class QuranAudioModule {
  /// Creates a [QuranAudioRepository] instance

  static QuranAudioRepository createRepository() {
    return QuranAudioRepositoryImpl(
      localRecitersService: LocalRecitersService(),
    );
  }

  /// Creates a [QuranAudioCubit] instance
  static QuranAudioCubit createCubit() {
    return QuranAudioCubit(repository: createRepository());
  }
}
