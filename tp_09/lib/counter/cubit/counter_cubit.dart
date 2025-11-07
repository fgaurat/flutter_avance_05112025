import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
  void reset() => emit(0);
  Future<void> resetAsync() async {
    await Future.delayed(Duration(seconds: 1));
    emit(0);
  }

}
