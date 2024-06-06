import 'dart:math' as math; // Add this line to import the math package.

import 'package:flutter/material.dart';
class WavePainter extends CustomPainter {
  final Color color;
  final double progress;

  WavePainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    double waveHeight = 20.0;
    double waveFrequency = 2.0;
    double waveSpeed = 0.5;

    Path path = Path();
    path.moveTo(0, size.height);

    for (double i = 0; i <= size.width; i++) {
      double y = size.height -
          (waveHeight * (1 - progress)) *
              (0.5 +
                  0.5 *
                      (1 +
                          math.sin(i * waveFrequency +
                              progress * 2 * math.pi * waveSpeed)));
      path.lineTo(i, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
