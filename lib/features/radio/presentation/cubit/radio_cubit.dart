import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/radio_station.dart';
import '../../domain/repositories/radio_repository.dart';
import 'radio_state.dart';

class RadioCubit extends Cubit<RadioState> {
  final RadioRepository repository;

  RadioCubit({
    required this.repository,
  }) : super(const RadioInitial());

  Future<void> playRadio() async {
    emit(const RadioLoading());

    try {
      final RadioStation station =
      await repository.getCairoQuranRadio();

      // Update the UI immediately.
      emit(
        RadioPlaying(station),
      );


      await repository.play(station);
    } catch (e) {
      emit(
        const RadioError(
          'تعذر تشغيل إذاعة القرآن الكريم',
        ),
      );
    }
  }

  Future<void> pauseRadio() async {
    try {
      final currentState = state;

      if (currentState is! RadioPlaying) {
        return;
      }

      await repository.pause();

      emit(
        RadioPaused(
          currentState.station,
        ),
      );
    } catch (e) {
      emit(
        const RadioError(
          'حدث خطأ أثناء إيقاف الإذاعة مؤقتًا',
        ),
      );
    }
  }

  Future<void> resumeRadio() async {
    final currentState = state;

    if (currentState is! RadioPaused) {
      return;
    }

    // Update the UI immediately.
    emit(
      RadioPlaying(
        currentState.station,
      ),
    );

    try {
      // Do not wait for play() to finish.
      // The Future stays pending while the radio is playing.
      unawaited(
        repository.play(
          currentState.station,
        ),
      );
    } catch (e) {
      emit(
        const RadioError(
          'تعذر استئناف الإذاعة',
        ),
      );
    }
  }

  Future<void> stopRadio() async {
    try {
      await repository.stop();

      emit(const RadioInitial());
    } catch (e) {
      emit(
        const RadioError(
          'تعذر إيقاف الإذاعة',
        ),
      );
    }
  }
}