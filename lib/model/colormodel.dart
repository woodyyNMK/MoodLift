import 'dart:math';
import 'package:flutter/material.dart';

class BackgroundColors {
  static final _random = Random();

  static LinearGradient getSentimentColor(String sentiment) {
    switch (sentiment) {
      case 'Positive':
        final gradients = [
          const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFD700), // Gold
              Color(0xFFFFA07A), // Light Salmon
              Color(0xFFFF69B4), // Hot Pink
            ],
          ),
          const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF83FF21), // Lime
              Color(0xFF40E0D0), // Turquoise
              Color(0xFF87CEEB), // Sky Blue
            ],
          ),
          const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFC0CB), // Pink
              Color(0xFFDDA0DD), // Plum
              Color(0xFFFFFFFF), // White
            ],
          ),
        ];
        return gradients[_random.nextInt(gradients.length)];
      case 'Negative':
        final gradients = [
          const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2E8B57),
              Color(0xFF4682B4),
              Color(0xFFE6E6FA),
            ],
          ),
          const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF9ABCA7),
              Color(0xFFA1DBCD),
              Color(0xFFE0FFFF),
            ],
          ),
          const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5DEB3),
              Color(0xFFDEB887),
              Color(0xFFD2B48C),
            ],
          ),
        ];
        return gradients[_random.nextInt(gradients.length)];
      case 'Neutral':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.white, Colors.white],
        );

      default:
        throw ArgumentError('Invalid sentiment: $sentiment');
    }
  }
}
