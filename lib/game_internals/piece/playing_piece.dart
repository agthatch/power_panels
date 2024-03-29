import 'dart:async';

import 'package:card/game_internals/piece/array_transformer.dart';
import 'package:card/game_internals/piece/piece_data.dart';
import 'package:card/game_internals/rotation.dart';
import 'package:card/game_internals/xy_coordinate.dart';

class PlayingPiece {
  final Shape shape;
  late List<List<bool>> currentShape;
  late List<XYCoordinate> nodes;
  late final int maxX;
  late final int maxY;
  bool mirrored = false;
  bool isStaged = false;
  Rotation rotation = Rotation.R0;
  XYCoordinate? handledNodeCoordinate;

  final StreamController<void> _playerChanges =
      StreamController<void>.broadcast();

  Stream<void> get playerChanges => _playerChanges.stream;

  PlayingPiece(this.shape) {
    mirrored = false;
    rotation = Rotation.R0;
    maxX = shape.maxX();
    maxY = shape.maxY();
    currentShape = shape.asBools();
    nodes = shape.getNodes();
  }

  factory PlayingPiece.fromShape(Shape shape) {
    return PlayingPiece(shape);
  }

  int get size => nodes.length;

  static PlayingPiece generate(int index) {
    return PlayingPiece.fromShape(
        Shape.allShapes[index % Shape.allShapes.length]);
    // Shapes.allShapes[5]);
  }

  void rotatePositive90() {
    currentShape = ArrayTransformer.rotateShapeClockwise(currentShape);
    updateNodesBasedOnShape(currentShape);
    rotation = rotation.rotatePositive90();
    _playerChanges.add(null);
  }

  void mirror() {
    currentShape = ArrayTransformer.mirrorAboutX(currentShape);
    updateNodesBasedOnShape(currentShape);
    mirrored = !mirrored;
    _playerChanges.add(null);
  }

  void updateNodesBasedOnShape(List<List<bool>> shape) {
    nodes = [];
    for (int i = 0; i < shape.length; i++) {
      for (int j = 0; j < shape[0].length; j++) {
        if (shape[i][j]) {
          nodes.add(XYCoordinate(x: j, y: i));
        }
      }
    }
  }

  void setHandledNodeCoordinate(int row, int col) {
    handledNodeCoordinate = XYCoordinate(x: col, y: row);
  }

  XYCoordinate getOffsetFromClickedNodeToTopLeftCorner() {
    return XYCoordinate(x: 0, y: 0)
        .negativeOffsetBy(handledNodeCoordinate ?? XYCoordinate(x: 0, y: 0));
  }

  int currentMaxX() {
    return currentShape[0].length;
  }

  void rotate(Rotation rotation) {
    int timesToRotatePositive90 = 0;
    switch (rotation) {
      case Rotation.R0:
        timesToRotatePositive90 = 0;
      case Rotation.R90:
        timesToRotatePositive90 = 1;
      case Rotation.R180:
        timesToRotatePositive90 = 2;
      case Rotation.R270:
        timesToRotatePositive90 = 3;
    }

    for (int i = 0; i < timesToRotatePositive90; i++) {
      rotatePositive90();
    }
  }

  PlayingPiece clone() {
    PlayingPiece res = PlayingPiece(shape);
    res.currentShape = currentShape.map((row) => List<bool>.from(row)).toList();
    res.nodes = nodes.toList();
    res.mirrored = mirrored;
    res.isStaged = isStaged;
    res.rotation = rotation;
    res.handledNodeCoordinate = handledNodeCoordinate;

    return res;
  }
}
