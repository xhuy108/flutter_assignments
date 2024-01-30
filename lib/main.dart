import 'dart:math';

import 'package:advanced/painter/coordinate_painter.dart';
import 'package:advanced/model/shape.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<_CoordinateSystemState> coordinateSystemKey =
        GlobalKey<_CoordinateSystemState>();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Coordinate System'),
        ),
        body: CoordinateSystem(key: coordinateSystemKey),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                coordinateSystemKey.currentState!.addRectangle();
              },
              tooltip: 'Add Rectangle',
              child: const Icon(Icons.rectangle_outlined),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              onPressed: () {
                coordinateSystemKey.currentState!.addCircle();
              },
              tooltip: 'Add Circle',
              child: const Icon(Icons.circle_outlined),
            ),
          ],
        ),
      ),
    );
  }
}

class CoordinateSystem extends StatefulWidget {
  const CoordinateSystem({super.key});

  @override
  State<CoordinateSystem> createState() => _CoordinateSystemState();
}

class _CoordinateSystemState extends State<CoordinateSystem> {
  Offset origin = const Offset(0, 0);
  List<Shape> shapes = [];

  double scale = 1.0;
  double baseScale = 1.0;
  double minScale = 0.2;
  double maxScale = 10.0;

  Offset? lastFocalPoint;

  double smallestSubdivision = 1.0;
  List<double> subdivisions = [0.2, 0.5, 1, 2, 5, 10];

  Shape? selectedShape;

  double get currentSubdivision {
    if (scale >= 4) {
      return subdivisions.first;
    }
    if (scale >= 2) {
      return subdivisions[1];
    }

    if (scale <= 0.2) {
      return subdivisions.last;
    }
    if (scale <= 0.5) {
      return subdivisions[4];
    }
    if (scale < 1) {
      return subdivisions[3];
    }

    return subdivisions[2];
  }

  void addRectangle() {
    setState(() {
      final center = Offset(context.size!.width / 2, context.size!.height / 2);
      final centerInCoordinateSystem = (center - origin);

      // print('center: $center - origin: $origin - scale: $scale');
      // print('centerInCoordinateSystem: $centerInCoordinateSystem');

      shapes.add(
        Shape.rectangle(
          color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
          width: Random().nextDouble() * 250,
          height: Random().nextDouble() * 250,
          offset: centerInCoordinateSystem,
        ),
      );
    });
  }

  void addCircle() {
    setState(() {
      final center = Offset(context.size!.width / 2, context.size!.height / 2);
      final centerInCoordinateSystem = (center - origin);

      // print('add circle');
      // print('center: $center - origin: $origin - scale: $scale');
      // print('centerInCoordinateSystem: $centerInCoordinateSystem');
      shapes.add(
        Shape.circle(
          color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
          radius: Random().nextDouble() * 150,
          offset: centerInCoordinateSystem,
        ),
      );
    });
  }

  void selectShape(Offset position) {
    // print('Shape selected at position: $position');
    for (var shape in shapes.reversed) {
      // print('${shape.offset!}');
      if (shape.contains(position)) {
        // print('${shape.offset!}');
        // print('Shape selected: ${shape.offset! - position}');
        selectedShape = shape;
        break;
      }
    }
  }

  void moveShape(Offset position) {
    // print('Moving shape to position: $position');
    // print(selectedShape);
    if (selectedShape != null) {
      // print('Moving shape to position: $position');
      setState(() {
        // Remove the selected shape from the shapes list
        shapes.remove(selectedShape);

        // Update the offset of the selected shape
        selectedShape!.offset = position;

        // Add the selected shape back to the end of the shapes list
        shapes.add(selectedShape!);
      });
    }
  }

  void deselectShape() {
    selectedShape = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) {
        // print('long press start');

        // print('newOrigin: $origin');
        // print('details.localPosition: ${details.localPosition}');
        // print('scale: $scale');
        final center =
            Offset(context.size!.width / 2, context.size!.height / 2) +
                origin * scale;

        final positionInShapeCoordinates = (details.localPosition / scale -
            origin * scale -
            center * (1 - scale) / scale);

        // print('positionInShapeCoordinates: $positionInShapeCoordinates');

        selectShape(positionInShapeCoordinates);
      },
      onLongPressMoveUpdate: (details) {
        // print('long press move update');

        // print('origin: $origin - scale: $scale');
        // print('details.localPosition: ${details.localPosition}');
        // print('origin: $origin');

        final center =
            Offset(context.size!.width / 2, context.size!.height / 2) +
                origin * scale;

        final positionInShapeCoordinates = (details.localPosition / scale -
            origin * scale -
            center * (1 - scale) / scale);

        // print('origin: $origin - scale: $scale');
        // print(selectedShape);
        if (selectedShape != null) {
          setState(() {
            moveShape(positionInShapeCoordinates);
          });
        }
      },
      onLongPressEnd: (details) {
        // print('long press end');

        deselectShape();
      },
      onScaleStart: (details) {
        debugPrint('scale start');
        baseScale = scale;
        lastFocalPoint = details.localFocalPoint;
        // print(details.localFocalPoint);
      },
      onScaleUpdate: (details) {
        debugPrint('scale update');
        setState(() {
          // Calculate the new scale based on the initial scale and the scale of the gesture
          scale = (baseScale * details.scale).clamp(minScale, maxScale);
          // print(
          //     'scale: $scale - baseScale: $baseScale - details.scale: ${details.scale}');

          // Calculate the new origin based on the initial focal point, the current focal point, and the new scale
          final offset = details.localFocalPoint - lastFocalPoint!;
          origin += offset / scale;

          // Update the last focal point

          lastFocalPoint = details.localFocalPoint;

          // Update the smallest subdivision based on the new scale
          smallestSubdivision = currentSubdivision;
        });
      },
      onScaleEnd: (details) {
        baseScale = scale;
        lastFocalPoint = null;
      },
      child: CustomPaint(
        painter: CoordinatePainter(
          origin,
          shapes: shapes,
          scale: scale,
          unit: smallestSubdivision,
          smallestSubdivision: smallestSubdivision,
        ),
        child: Container(),
      ),
    );
  }
}
