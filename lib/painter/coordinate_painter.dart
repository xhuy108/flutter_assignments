import 'package:advanced/model/shape.dart';
import 'package:flutter/material.dart';

class CoordinatePainter extends CustomPainter {
  final Offset origin;
  final double unit;
  final double scale;
  final List<Shape> shapes;
  final double smallestSubdivision;

  CoordinatePainter(
    this.origin, {
    required this.unit,
    required this.shapes,
    required this.scale,
    required this.smallestSubdivision,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final mainAxisPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    final double centerX = (size.width / 2 + origin.dx) * scale;
    final double centerY = (size.height / 2 + origin.dy) * scale;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Draw main axis
    drawMainAxis(
      canvas: canvas,
      size: size,
      centerX: centerX,
      centerY: centerY,
      textPainter: textPainter,
      mainAxisPaint: mainAxisPaint,
    );

    final subCoordinatePaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;

    final minX = ((0 - origin.dx) / (30 * scale)).floor() - size.width / 2;
    final maxX =
        ((size.width - origin.dx) / (30 * scale)).ceil() + size.width / 2;

    // Draw unit lines on X axis
    for (double x = unit; x <= maxX; x += smallestSubdivision) {
      canvas.drawLine(
        Offset(centerX + x * 30 * scale, centerY - 5),
        Offset(centerX + x * 30 * scale, centerY + 5),
        subCoordinatePaint,
      );

      String unitNum = '';

      if (x.toStringAsFixed(1) == x.round().toDouble().toString()) {
        canvas.drawLine(
          Offset(centerX + x * 30 * scale, 0),
          Offset(centerX + x * 30 * scale, size.height),
          subCoordinatePaint,
        );
        unitNum = x.round().toString();
      } else {
        unitNum = x.toStringAsFixed(1);
      }

      textPainter.text = TextSpan(
        text: unitNum,
        style: const TextStyle(color: Colors.black),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
            centerX +
                x * 30 * scale -
                (unitNum.length * unitNum.length + unitNum.length + 1),
            centerY + 6),
      );
    }

    for (double x = unit; x >= minX; x -= smallestSubdivision) {
      if (x >= 0) continue;

      canvas.drawLine(
        Offset(centerX + x * 30 * scale, centerY - 5),
        Offset(centerX + x * 30 * scale, centerY + 5),
        subCoordinatePaint,
      );
      String unitNum = '';

      if (x.toStringAsFixed(1) == x.roundToDouble().toString()) {
        canvas.drawLine(
          Offset(centerX + x * 30 * scale, 0),
          Offset(centerX + x * 30 * scale, size.height),
          subCoordinatePaint,
        );
        unitNum = x.round().toString();
      } else {
        unitNum = x.toStringAsFixed(1);
      }

      textPainter.text = TextSpan(
        text: unitNum,
        style: const TextStyle(color: Colors.black),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
            centerX +
                x * 30 * scale -
                (unitNum.length * unitNum.length + unitNum.length + 1),
            centerY + 6),
      );
    }

    final minY = ((0 - origin.dy) / (30 * scale)).ceil() - size.height / 2;
    final maxY =
        ((size.height - origin.dy) / (30 * scale)).ceil() + size.height / 2;

    // Draw unit lines on Y axis
    for (double y = unit; y <= maxY; y += smallestSubdivision) {
      canvas.drawLine(
        Offset(centerX - 5, centerY - y * 30 * scale),
        Offset(centerX + 5, centerY - y * 30 * scale),
        subCoordinatePaint,
      );

      String unitNum = '';

      if (y.toStringAsFixed(1) == y.roundToDouble().toString()) {
        canvas.drawLine(
          Offset(0, centerY - y * 30 * scale),
          Offset(size.width, centerY - y * 30 * scale),
          subCoordinatePaint,
        );
        unitNum = y.round().toString();
      } else {
        unitNum = y.toStringAsFixed(1);
      }

      textPainter.text = TextSpan(
        text: unitNum,
        style: const TextStyle(color: Colors.black),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          centerX + 10,
          centerY - y * 30 * scale - 9,
        ),
      );
    }
    for (double y = unit; y >= minY; y -= smallestSubdivision) {
      if (y >= 0) continue;

      canvas.drawLine(
        Offset(centerX - 5, centerY - y * 30 * scale),
        Offset(centerX + 5, centerY - y * 30 * scale),
        subCoordinatePaint,
      );
      String unitNum = '';

      if (y.toStringAsFixed(1) == y.roundToDouble().toString()) {
        canvas.drawLine(
          Offset(0, centerY - y * 30 * scale),
          Offset(size.width, centerY - y * 30 * scale),
          subCoordinatePaint,
        );
        unitNum = y.round().toString();
      } else {
        unitNum = y.toStringAsFixed(1);
      }

      textPainter.text = TextSpan(
        text: unitNum,
        style: const TextStyle(color: Colors.black),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          centerX + 10,
          centerY - y * 30 * scale - 9,
        ),
      );
    }

    // Draw shapes
    drawShapes(canvas);
  }

  void drawMainAxis({
    required Canvas canvas,
    required Size size,
    required double centerX,
    required double centerY,
    required TextPainter textPainter,
    required Paint mainAxisPaint,
  }) {
    // Draw X and Y axes
    canvas.drawLine(
      Offset(0, centerY),
      Offset(size.width, centerY),
      mainAxisPaint,
    );
    canvas.drawLine(
      Offset(centerX, 0),
      Offset(centerX, size.height),
      mainAxisPaint,
    );

    textPainter.text = const TextSpan(
      text: 'O',
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        centerX - 16,
        centerY + 5,
      ),
    );
  }

  void drawUnitLine({
    required Canvas canvas,
    required double value,
    required TextPainter textPainter,
    required Paint subCoordinatePaint,
    required Offset textOffset,
    required Offset miniSubLineStart,
    required Offset miniSubLineEnd,
    required Offset longSubLineStart,
    required Offset longSubLineEnd,
  }) {
    canvas.drawLine(
      miniSubLineStart,
      miniSubLineEnd,
      subCoordinatePaint,
    );

    String unitNum = '';

    if (value.toStringAsFixed(1) == value.roundToDouble().toString()) {
      canvas.drawLine(
        longSubLineStart,
        longSubLineEnd,
        subCoordinatePaint,
      );
      unitNum = value.round().toString();
    } else {
      unitNum = value.toStringAsFixed(1);
    }

    textPainter.text = TextSpan(
      text: unitNum,
      style: const TextStyle(color: Colors.black),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      textOffset,
    );
  }

  void drawShapes(Canvas canvas) {
    for (var shape in shapes) {
      final paint = Paint()..color = shape.color;

      final transformedOffset = (shape.offset! + origin) * scale;

      if (shape.isRectangle) {
        canvas.drawRect(
          Rect.fromCenter(
            center: transformedOffset,
            width: shape.width! * scale,
            height: shape.height! * scale,
          ),
          paint,
        );
      } else {
        canvas.drawCircle(
          transformedOffset,
          shape.radius! * scale,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
