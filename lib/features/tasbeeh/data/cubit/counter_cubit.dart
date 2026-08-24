import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CounterCubit extends Cubit<Map<int, int>> {
  CounterCubit() : super({}) {
    _loadCounters();
  }

  static const String _counterPrefix =
      'tasbeeh_counter_';

  // ============================================================
  // Total
  // ============================================================

  int get total {
    return state.values.fold(
      0,
          (sum, count) => sum + count,
    );
  }

  // ============================================================
  // Load Counters
  // ============================================================

  Future<void> _loadCounters() async {
    final prefs =
    await SharedPreferences.getInstance();

    final counters = <int, int>{};

    for (final key in prefs.getKeys()) {
      if (!key.startsWith(_counterPrefix)) {
        continue;
      }

      final indexString =
      key.substring(_counterPrefix.length);

      final index =
      int.tryParse(indexString);

      if (index == null) {
        continue;
      }

      final count =
          prefs.getInt(key) ?? 0;

      counters[index] = count;
    }

    emit(counters);
  }

  // ============================================================
  // Increment
  // ============================================================

  Future<void> increment(int index) async {
    final newMap =
    Map<int, int>.from(state);

    final newCount =
        (newMap[index] ?? 0) + 1;

    newMap[index] = newCount;

    // Update UI immediately
    emit(newMap);

    // Save this counter
    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setInt(
      '$_counterPrefix$index',
      newCount,
    );
  }

  // ============================================================
  // Reset One Counter
  // ============================================================

  Future<void> reset(int index) async {
    final newMap =
    Map<int, int>.from(state);

    newMap.remove(index);

    emit(newMap);

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.remove(
      '$_counterPrefix$index',
    );
  }

  // ============================================================
  // Reset Session
  // ============================================================

  void resetSession() {
    emit({});
  }

  // ============================================================
  // Reset All Counters
  // ============================================================

  Future<void> resetAll() async {
    final prefs =
    await SharedPreferences.getInstance();

    final keys = prefs
        .getKeys()
        .where(
          (key) =>
          key.startsWith(
            _counterPrefix,
          ),
    )
        .toList();

    for (final key in keys) {
      await prefs.remove(key);
    }

    // Remove the old totalCount
    // that was causing the double counting.
    await prefs.remove('totalCount');

    emit({});
  }
}