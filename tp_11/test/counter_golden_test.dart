import 'dart:typed_data';
import 'dart:ui';
import 'dart:io'; // pour manipuler les fichiers et URI de test
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tp_11/main.dart';


main() {
  testWidgets('golden: écran d\'accueil', (WidgetTester tester) async {
    // AAA: Arrange, Act, Assert
    await tester.binding.setSurfaceSize(const Size(360, 640));
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MyApp),
      matchesGoldenFile('goldens/counter_initial.png'),
    );
  });
