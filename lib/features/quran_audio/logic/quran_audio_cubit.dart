// features/quran_audio/presentation/cubit/quran_audio_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisn_almuslim/features/quran_audio/data/models/reciter_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/repos/quran_audio_repository.dart';
import 'quran_audio_state.dart';

class QuranAudioCubit extends Cubit<QuranAudioState> {
  final QuranAudioRepository _repository;
  static const String _selectedReciterIdKey = 'selected_reciter_id';

  QuranAudioCubit({required QuranAudioRepository repository})
    : _repository = repository,
      super(const QuranAudioInitial());

  Future<void> loadReciters() async {
    try {
      emit(const QuranAudioLoading());

      final List<ReciterModel> reciters = await _repository.getReciters();

      if (reciters.isEmpty) {
        emit(const QuranAudioError('No reciters found'));
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final savedReciterId = prefs.getInt(_selectedReciterIdKey);

      ReciterModel? selectedReciter;
      if (savedReciterId != null) {
        selectedReciter = reciters.firstWhere(
              (r) => r.id == savedReciterId,
          orElse: () => reciters.first,
        );
      } else {
        selectedReciter = reciters.first;
      }

      emit(QuranAudioLoaded(reciters: reciters, selectedReciter: selectedReciter));
    } catch (e) {
      // Emit error state
      emit(QuranAudioError('Failed to load reciters: ${e.toString()}'));
    }
  }

  void selectReciter(ReciterModel reciter) {
    final currentState = state;

    // Only update if we're in loaded state
    if (currentState is QuranAudioLoaded) {
      _saveSelectedReciterId(reciter.id);
      emit(
        QuranAudioLoaded(
          reciters: currentState.reciters,
          selectedReciter: reciter,
        ),
      );
    } else {
      print('Cannot select reciter in state: ${currentState.runtimeType}');
    }
  }

  ReciterModel? get selectedReciter {
    final currentState = state;
    if (currentState is QuranAudioLoaded) {
      return currentState.selectedReciter;
    }
    return null;
  }

  bool get isLoaded => state is QuranAudioLoaded;

  bool get isLoading => state is QuranAudioLoading;

  bool get hasError => state is QuranAudioError;

  String? get errorMessage {
    final currentState = state;
    if (currentState is QuranAudioError) {
      return currentState.message;
    }
    return null;
  }


  Future<void> _saveSelectedReciterId(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_selectedReciterIdKey, id);
    } catch (e) {
      print('❌ Failed to save selected reciter: $e');
    }
  }
}
