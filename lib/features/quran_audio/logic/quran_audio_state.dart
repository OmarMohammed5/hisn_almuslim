import 'package:equatable/equatable.dart';
import 'package:hisn_almuslim/features/quran_audio/data/models/reciter_model.dart';

abstract class QuranAudioState extends Equatable {
  const QuranAudioState();

  @override
  List<Object?> get props => [];
}

class QuranAudioInitial extends QuranAudioState {
  const QuranAudioInitial();
}

class QuranAudioLoading extends QuranAudioState {
  const QuranAudioLoading();
}

class QuranAudioLoaded extends QuranAudioState {
  final List<ReciterModel> reciters;
  final ReciterModel? selectedReciter;

  const QuranAudioLoaded({required this.reciters, this.selectedReciter});

  ReciterModel? get effectiveSelectedReciter {
    return selectedReciter ?? (reciters.isNotEmpty ? reciters.first : null);
  }

  @override
  List<Object?> get props => [reciters, selectedReciter];
}

class QuranAudioError extends QuranAudioState {
  final String message;

  const QuranAudioError(this.message);

  @override
  List<Object?> get props => [message];
}
