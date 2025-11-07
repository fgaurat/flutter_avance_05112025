import 'package:flutter/material.dart';

class MediaQueryBanner extends StatelessWidget {
  const MediaQueryBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final largeur = media.size.width;
    final hauteur = media.size.height;
    final orientation = media.orientation;
    final textScale = media.textScaleFactor;

    return Center(
      child: Container(
        width: double.infinity,
        child: Text(
          'hauteur: ${hauteur.toStringAsFixed(0)} px\n'
          'largeur: ${largeur.toStringAsFixed(0)} px\n'
          'orientation: $orientation\n'
          'textScaleFactor: ${textScale.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
