import 'package:flutter/material.dart';
import 'package:tp_12/show_constraints.dart';

class TestConstraints extends StatelessWidget {
  const TestConstraints({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Constraints')),
      body: Container(
        width: 200,
        height: 200,
        color: Colors.blue,
        child: ShowConstraints(
          label: "Red Container",
          child: Center(
            child: Container(width: 100, height: 100, color: Colors.red),
          ),
        ),
      ),
    );
  }
}
