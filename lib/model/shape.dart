import 'package:flutter/material.dart';

class Shape {
  final Color color;
  final double? width;
  final double? height;
  final double? radius;
  final bool isRectangle;
  Offset? offset;

  Shape.rectangle({
    required this.color,
    required this.width,
    required this.height,
    this.offset,
  })  : isRectangle = true,
        radius = null;

  Shape.circle({
    required this.color,
    required this.radius,
    this.offset,
  })  : isRectangle = false,
        width = null,
        height = null;

  bool contains(Offset position) {
    if (isRectangle) {
      return offset!.dx - width! / 2 <= position.dx &&
          offset!.dx + width! / 2 >= position.dx &&
          offset!.dy - height! / 2 <= position.dy &&
          offset!.dy + height! / 2 >= position.dy;
    } else {
      return (offset! - position).distance <= radius!;
    }
  }
}
