import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CounterEvent {}

class Increment extends CounterEvent {}

class Decrement extends CounterEvent {}

class Reset extends CounterEvent {}

class CounterState {
  final int value;
  final bool loading;

  const CounterState({required this.value, this.loading = false});

  CounterState copyWith({int? value, bool? loading}) {
    return CounterState(
      value: value ?? this.value,
      loading: loading ?? this.loading,
    );
  }

  @override
  String toString() {
    return 'CounterState(value: $value, loading: $loading)';
  }
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState(value: 0)) {
    on<Increment>(_onIncrement);
    on<Decrement>(_onDecrement);
    on<Reset>(_onReset);
  }

  Future<void> _onIncrement(Increment event, Emitter<CounterState> emit) async {
    emit(state.copyWith(loading: true));
    await Future.delayed(const Duration(milliseconds: 500));
    emit(state.copyWith(value: state.value + 1, loading: false));
  }

  Future<void> _onDecrement(Decrement event, Emitter<CounterState> emit) async {
    emit(state.copyWith(loading: true));
    await Future.delayed(const Duration(milliseconds: 500));
    emit(state.copyWith(value: state.value - 1, loading: false));
  }

  Future<void> _onReset(Reset event, Emitter<CounterState> emit) async {
    emit(state.copyWith(loading: true));
    await Future.delayed(const Duration(milliseconds: 500));
    emit(state.copyWith(value: 0, loading: false));
  }
}
