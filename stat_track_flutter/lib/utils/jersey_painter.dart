import 'package:flutter/material.dart';

class JerseyIconPainter extends CustomPainter {
  final Color jerseyColor;

  JerseyIconPainter({required this.jerseyColor});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = jerseyColor
      ..style = PaintingStyle.fill;

    double width = size.width;
    double height = size.height;

    // Create the path for the jersey
    Path path = Path()
      ..moveTo(width * 0.5, 0) // Neckline top middle
    // Right shoulder
      ..lineTo(width * 0.75, height * 0.2)
    // Right arm
      ..lineTo(width, height * 0.3)
      ..lineTo(width * 0.75, height * 0.4)
    // Right side of the jersey
      ..lineTo(width * 0.75, height * 0.8)
    // Bottom of the jersey
      ..lineTo(width * 0.25, height * 0.8)
    // Left side of the jersey
      ..lineTo(width * 0.25, height * 0.4)
    // Left arm
      ..lineTo(0, height * 0.3)
      ..lineTo(width * 0.25, height * 0.2)
    // Back to neckline left shoulder
      ..lineTo(width * 0.5, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
