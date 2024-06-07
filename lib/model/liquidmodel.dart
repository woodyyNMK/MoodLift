import 'package:flutter/material.dart';
import 'dart:math';

class WaveCircle extends StatefulWidget {
  final double percentage; // Expected range from 0.0 to 1.0

  const WaveCircle({
    super.key,
    required this.percentage,
  });

  @override
  // ignore: library_private_types_in_public_api
  _WaveCircleState createState() => _WaveCircleState();
}

class _WaveCircleState extends State<WaveCircle> with TickerProviderStateMixin {
  late AnimationController _fillController;
  late Animation<double> _fillAnimation;
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();

    _fillController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fillAnimation = Tween<double>(begin: 0.0, end: widget.percentage)
        .animate(_fillController)
      ..addListener(() {
        setState(() {});
      });

    _waveController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _waveAnimation =
        Tween<double>(begin: 0.0, end: 2 * pi).animate(_waveController)
          ..addListener(() {
            setState(() {});
          });

    _fillController.forward();
    _waveController.repeat();
  }

  @override
  void didUpdateWidget(WaveCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percentage != widget.percentage) {
      _fillAnimation =
          Tween<double>(begin: _fillAnimation.value, end: widget.percentage)
              .animate(_fillController)
            ..addListener(() {
              setState(() {});
            });
      _fillController
        ..reset()
        ..forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WaveCirclePainter(_fillAnimation.value, _waveAnimation.value),
      child: Container(
        width: 200,
        height: 200,
        alignment: Alignment.center,
        child: Text(
          "${(_fillAnimation.value * 100).toStringAsFixed(0)}%",
          style: const TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fillController.dispose();
    _waveController.dispose();
    super.dispose();
  }
}

class WaveCirclePainter extends CustomPainter {
  final double percentage;
  final double phase;

  WaveCirclePainter(this.percentage, this.phase);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    double waveHeight = 20;
    Path path = Path();

    double radius = size.width / 2;
    Offset center = Offset(size.width / 2, size.height / 2);

    Path circlePath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
    canvas.clipPath(circlePath);

    path.moveTo(center.dx - radius, center.dy + radius); // Start point
    for (double i = 0; i <= size.width; i++) {
      path.lineTo(
        i,
        sin((i / size.width * 2 * pi) + (percentage * 2 * pi) + phase) *
                waveHeight +
            center.dy +
            radius -
            (percentage * (size.height + waveHeight)),
      );
    }

    path.lineTo(center.dx + radius, center.dy + radius); // End point
    path.lineTo(
        center.dx - radius, center.dy + radius); // Return to start point
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
