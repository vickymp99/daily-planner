import 'package:flutter/material.dart';
import 'dart:math';

class CustomCircularIndicator extends StatelessWidget {
  final double currentValue;
  final double totalValue;
  final double size;
  final double strokeWidth;

  const CustomCircularIndicator({
    super.key,
    required this.currentValue,
    required this.totalValue,
    this.size = 120.0,
    this.strokeWidth = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    double percent = (currentValue / totalValue).clamp(0.0, 1.0);

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CirclePainter(percent, strokeWidth),
        child: Center(
          child: Text(
            "${(percent * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              fontSize: strokeWidth,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final double percent;
  final double strokeValue;

  _CirclePainter(this.percent, this.strokeValue);

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = strokeValue;
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = (size.width - strokeWidth) / 2;

    Paint backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    Paint progressPaint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    double sweepAngle = 2 * pi * percent;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // start from top
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
