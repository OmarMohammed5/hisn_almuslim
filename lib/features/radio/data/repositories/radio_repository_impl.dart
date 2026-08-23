import 'package:audio_service/audio_service.dart';
import '../../../quran_audio/data/services/app_audio_player_service.dart';
import '../../domain/entities/radio_station.dart';
import '../../domain/repositories/radio_repository.dart';
import '../datasources/radio_local_data_source.dart';

class RadioRepositoryImpl implements RadioRepository {
  final RadioLocalDataSource localDataSource;
  final AudioPlayerService audioPlayerService;

  RadioRepositoryImpl({
    required this.localDataSource,
    required this.audioPlayerService,
  });

  @override
  Future<RadioStation> getCairoQuranRadio() {
    return localDataSource.getCairoQuranRadio();
  }

  @override
  Future<void> play(RadioStation station) async {
    await audioPlayerService.loadTrack(
      url: station.streamUrl,
      mediaItem: MediaItem(
        id: station.id,
        title: station.name,
        // album: 'إذاعة القرآن الكريم',
      ),
    );

    await audioPlayerService.play();
  }

  @override
  Future<void> pause() {
    return audioPlayerService.pause();
  }

  @override
  Future<void> stop() {
    return audioPlayerService.stop();
  }
}