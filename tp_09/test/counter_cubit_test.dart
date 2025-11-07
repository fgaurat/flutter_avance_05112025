import 'package:flutter_test/flutter_test.dart';
import 'package:tp_09/counter/cubit/counter_cubit.dart';

void main() {
  late CounterCubit cubit;

  setUp(() {
    cubit = CounterCubit();
  });

  tearDown(() {
    cubit.close();
  });

  test('starts at zero', () {
    expect(cubit.state, 0);
  });

  test('increment increases the state by one per call', () {
    cubit.increment();
    expect(cubit.state, 1);

    cubit.increment();
    expect(cubit.state, 2);
  });

  test('decrement decreases the state by one from the current value', () {
    cubit
      ..increment()
      ..increment(); // state: 2

    cubit.decrement();
    expect(cubit.state, 1);
  });

  test('reset brings the state back to zero', () {
    cubit
      ..increment()
      ..increment();

    cubit.reset();
    expect(cubit.state, 0);
  });

  test('resetAsync resets to zero after the asynchronous delay', () async {
    cubit.increment();

    final resetFuture = cubit.resetAsync();
    expect(cubit.state, 1, reason: 'state updates only after the async delay');
    await resetFuture;
    expect(cubit.state, 0);
  });
}
