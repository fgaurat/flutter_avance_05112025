import 'package:flutter/material.dart';
import 'package:tp_01/features/counter/inherited/counter_data.dart';

class CounterProvider extends StatefulWidget {
  const CounterProvider({super.key, required this.child});

  final Widget child;

  @override
  State<CounterProvider> createState() => _CounterProviderState();
}

class _CounterProviderState extends State<CounterProvider> {
  int _count = 0;

  void _increment() {
    setState(() {
      _count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CounterData(
      value: _count,
      increment: _increment,
      child: widget.child,
    );
  }
}
