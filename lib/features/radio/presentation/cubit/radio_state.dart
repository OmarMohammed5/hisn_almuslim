import 'package:equatable/equatable.dart';

import '../../domain/entities/radio_station.dart';

abstract class RadioState extends Equatable {
  const RadioState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class RadioInitial extends RadioState {
  const RadioInitial();
}

/// Loading stream
class RadioLoading extends RadioState {
  const RadioLoading();
}

/// Radio is playing
class RadioPlaying extends RadioState {
  final RadioStation station;

  const RadioPlaying(this.station);

  @override
  List<Object?> get props => [station];
}

/// Radio is paused
class RadioPaused extends RadioState {
  final RadioStation station;

  const RadioPaused(this.station);

  @override
  List<Object?> get props => [station];
}

/// Radio error
class RadioError extends RadioState {
  final String message;

  const RadioError(this.message);

  @override
  List<Object?> get props => [message];
}