import 'package:flutter/material.dart';
import 'package:tp_01/features/counter/inherited/counter_provider.dart';
import 'package:tp_01/features/counter/widgets/counter_text.dart';
import 'package:tp_01/features/counter/widgets/increment_button.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CounterProvider(
      child: Scaffold(
        appBar: AppBar(title: const Text('Counter Inherited Widget')),
        body: const Center(child: CounterText()),
        floatingActionButton: const IncrementButton(),
      ),
    );
  }
}
