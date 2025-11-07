import 'dart:typed_data';
import 'dart:ui';
import 'dart:io'; // pour manipuler les fichiers et URI de test
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tp_11/main.dart';

class TolerantGoldenFileComparator extends LocalFileComparator {
  final double tolerance; // Valeur entre 0 (strict) et 1 (tolérance maximale)

  TolerantGoldenFileComparator(super.testFile, {required this.tolerance});

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );
    final passed = result.passed || result.diffPercent <= tolerance;
    if (passed) {
      result.dispose();
      return true;
    }
    final error = await generateFailureOutput(result, golden, basedir);
    result.dispose();
    throw FlutterError(error);
  }
}

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

  testWidgets('golden: écran d\'accueil avec tolérance', (
    WidgetTester tester,
  ) async {
    // Sauvegarde du comparateur global
    final previousComparator = goldenFileComparator;
    // Initialise ton comparateur avec tolérance (exemple: 0.05 pour 5%)
    goldenFileComparator = TolerantGoldenFileComparator(
      Uri.parse('./test/goldens'),
      tolerance: 0.02, // Tolérance de 2%
    );

    // AAA: Arrange, Act, Assert
    await tester.binding.setSurfaceSize(const Size(360, 640));
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MyApp),
      matchesGoldenFile('goldens/counter_initial.png'),
    );

    // Restaure le comparateur pour ne pas affecter d'autres tests
    addTearDown(() {
      goldenFileComparator = previousComparator;
    });
  });
}
