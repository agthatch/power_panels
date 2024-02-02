import 'dart:async';

import 'package:card/game_internals/piece_shapes.dart';
import 'package:card/game_internals/array_transformer.dart';
import 'package:card/game_internals/rotation.dart';
import 'package:card/game_internals/xy_coordinate.dart';

class PlayingPiece {
  final List<List<bool>> originalShape;
  late List<List<bool>> currentShape;
  List<XYCoordinate> nodes;
  final int maxX;
  final int maxY;
  bool mirrored = false;
  bool isPlaced = false;
  Rotation rotation = Rotation.R0;
  XYCoordinate? handledNodeCoordinate;

  final StreamController<void> _playerChanges =
      StreamController<void>.broadcast();

  Stream<void> get playerChanges => _playerChanges.stream;

  PlayingPiece(this.originalShape, this.nodes, this.maxX, this.maxY) {
    mirrored = false;
    rotation = Rotation.R0;
    currentShape = originalShape;
  }

  factory PlayingPiece.fromShape(List<List<int>> input) {
    List<XYCoordinate> nodes = [];
    List<List<bool>> shape = [];
    int y = 0;
    int x = 0;
    for (y = 0; y < input.length; y++) {
      List<bool> row = [];
      for (x = 0; x < input[y].length; x++) {
        bool isNode = input[y][x] == 1;
        row.add(isNode);
        if (isNode) {
          nodes.add(XYCoordinate(x: x, y: y));
        }
      }
      shape.add(row);
    }

    return PlayingPiece(shape, nodes, x, y);
  }

  int get size => nodes.length;

  static PlayingPiece generate(int index) {
    return PlayingPiece.fromShape(
        Shapes.allShapes[index % Shapes.allShapes.length]);
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
}
