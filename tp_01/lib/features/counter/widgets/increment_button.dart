import 'package:flutter/material.dart';
import 'package:tp_01/features/counter/inherited/counter_data.dart';

class IncrementButton extends StatelessWidget {
  const IncrementButton({super.key});

  @override
  Widget build(BuildContext context) {
    final increment = CounterData.of(context).increment;

    return ElevatedButton(onPressed: increment, child: const Text('Increment'));
  }
}
