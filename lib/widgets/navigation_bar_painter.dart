import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class NavigationBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = const Color(0xFF222B45)
      ..style = PaintingStyle.fill;

    var activePaint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(5, 0),
        const Offset(90, 10),
        const [
          Color(0xFFFF3D71),
          Color(0xFFB81D5B),
        ],
      );

    var path = Path();

    path.lineTo(50, 0);

    path.quadraticBezierTo(70, 0, 80, 15);
    path.quadraticBezierTo(90, 40, 120, 40);
    path.quadraticBezierTo(150, 40, 160, 15);
    path.quadraticBezierTo(170, 0, 190, 0);

    path.lineTo(size.width, 0);

    path.lineTo(size.width, size.height);

    path.lineTo(0, size.height);

    path.close();

    canvas.drawPath(path, paint);

    // Define the shadow
    var shadowPaint = Paint()
      ..color = Color.fromRGBO(255, 61, 113, 0.50) // Shadow color
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 5); // Shadow blur

// Draw the shadow
    canvas.drawCircle(const Offset(121, 0), 32, shadowPaint);
    canvas.drawCircle(const Offset(121, 0), 32, activePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
