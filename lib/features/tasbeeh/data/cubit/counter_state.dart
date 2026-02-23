part of 'counter_cubit.dart';

// @immutable
sealed class CounterState {
  final int counter;

  const CounterState(this.counter);
}

final class CounterInitial extends CounterState {
  const CounterInitial(super.counter);
}

final class CounterAdd extends CounterState {
  const CounterAdd(super.counter);
}
