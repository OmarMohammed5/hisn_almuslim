import '../entities/radio_station.dart';

abstract class RadioRepository {
  Future<RadioStation> getCairoQuranRadio();

  Future<void> play(RadioStation station);

  Future<void> pause();

  Future<void> stop();
}