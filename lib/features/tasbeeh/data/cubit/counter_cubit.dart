import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CounterCubit extends Cubit<Map<int, int>> {
  CounterCubit() : super({}) {
    _loadTotal();
  }

  int _storedTotal = 0;

  int get total =>
      state.values.fold(0, (sum, count) => sum + count) + _storedTotal;

  Future<void> _loadTotal() async {
    final prefs = await SharedPreferences.getInstance();
    _storedTotal = prefs.getInt("totalCount") ?? 0;
    emit({});
  }

  Future<void> _saveTotal(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("totalCount", value);
  }

  void increment(int index) {
    final newMap = Map<int, int>.from(state);
    newMap[index] = (newMap[index] ?? 0) + 1;

    emit(newMap);

    final newTotal =
        newMap.values.fold(0, (sum, count) => sum + count) + _storedTotal;

    _saveTotal(newTotal);
  }

  void resetSession() {
    emit({}); // يمسح الكروت فقط
  }

  Future<void> resetAll() async {
    _storedTotal = 0;
    emit({});
    await _saveTotal(0);
  }
}
