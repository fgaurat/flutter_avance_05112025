import 'package:flutter/material.dart';
import 'package:tp_01/features/counter/inherited/counter_data.dart';

class CounterText extends StatelessWidget {
  const CounterText({super.key});

  @override
  Widget build(BuildContext context) {
    final counterValue = CounterData.of(context).value;

    return Text('Counter Value: $counterValue');
  }
}
