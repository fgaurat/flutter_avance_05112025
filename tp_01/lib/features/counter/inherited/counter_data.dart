import 'package:flutter/widgets.dart';

class CounterData extends InheritedWidget {
  const CounterData({
    super.key,
    required this.value,
    required this.increment,
    required super.child,
  });

  final int value;
  final VoidCallback increment;

  static CounterData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CounterData>();
  }

  static CounterData of(BuildContext context) {
    final CounterData? result = maybeOf(context);
    assert(result != null, 'No CounterData found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(CounterData oldWidget) => value != oldWidget.value;
}
