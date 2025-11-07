import 'package:flutter/material.dart';

class ShowConstraints extends StatelessWidget {
  final String label;
  final Widget child;
  const ShowConstraints({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      debugPrint(
          '$label: maxWidth=${constraints.maxWidth}, maxHeight=${constraints.maxHeight}');
      return child;
    });
  }
}
