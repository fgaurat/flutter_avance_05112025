import 'package:flutter/material.dart';

class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final largeur = constraints.maxWidth;
        final colonnes = largeur < 480
            ? 1
            : largeur < 840
            ? 2
            : (largeur < 1200 ? 4 : 6);
        return Stack(
          children: [
            GridView.count(
              padding: const EdgeInsets.all(16),
              crossAxisCount: colonnes,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: List.generate(
                24,
                (index) => Card(
                  color: Colors.blue.shade100,
                  child: Center(
                    child: Text(
                      'Élément ${index + 1}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 16,
              top: 16,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text(
                    'Largeur : ${largeur.toStringAsFixed(0)} px\n'
                    'Colonnes : $colonnes',
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
