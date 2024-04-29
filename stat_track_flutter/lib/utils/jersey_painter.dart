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
    // Start at the middle of the jersey at the top
      ..moveTo(width * 0.5, 0)
    // V-neck - make it wider
      ..lineTo(width * 0.4, height * 0.12)
      ..lineTo(width * 0.6, height * 0.12)
      ..lineTo(width * 0.5, 0)
    // Right shoulder
      ..lineTo(width * 0.75, height * 0.12)
    // Right sleeve - make it longer
      ..quadraticBezierTo(width * 0.88, height * 0.15, width * 0.88, height * 0.30)
      ..quadraticBezierTo(width * 0.88, height * 0.40, width * 0.75, height * 0.40)
    // Right side of the jersey
      ..lineTo(width * 0.75, height * 0.85)
    // Bottom of the jersey (curved)
      ..quadraticBezierTo(width * 0.5, height * 0.95, width * 0.25, height * 0.85)
    // Left side of the jersey
      ..lineTo(width * 0.25, height * 0.40)
    // Left sleeve - make it longer
      ..quadraticBezierTo(width * 0.12, height * 0.40, width * 0.12, height * 0.30)
      ..quadraticBezierTo(width * 0.12, height * 0.15, width * 0.25, height * 0.12)
    // Back to neckline left shoulder
      ..lineTo(width * 0.5, 0)
      ..close();

    canvas.drawPath(path, paint);

    // Everything below is additional detail. For a more simplistic look it can be removed
    // without any consequences minus less shadow and detail
    // Create a radial gradient to simulate light falling on the jersey
    final Gradient gradient = RadialGradient(
      colors: [
        Color(0xFF000000).withOpacity(0.5), // darker color for shadow
        jerseyColor.withOpacity(0.0), // transparent color
      ],
      stops: [0.5, 1.0],
    );

    // Define the rectangle bounds of the gradient
    Rect gradientRect = Rect.fromCircle(
      center: Offset(width * 0.5, height * 0.3), // change center as needed
      radius: width * 0.5,
    );

    // Define the paint for the gradient
    Paint gradientPaint = Paint()
      ..shader = gradient.createShader(gradientRect);

    // Apply the gradient over the jersey
    canvas.drawPath(path, gradientPaint);

    // Optionally, you can add a shadow to the jersey to give it more depth
    canvas.drawShadow(path, Colors.black, 4.0, false);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
