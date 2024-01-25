import 'package:card/game_internals/piece_shapes.dart';
import 'package:card/game_internals/rotation.dart';
import 'package:card/game_internals/xy_coordinate.dart';

class PlayingPiece {
  final List<List<bool>> shape;
  final List<XYCoordinate> nodes;
  final int maxX;
  final int maxY;
  bool mirrored = false;
  Rotation rotation = Rotation.R0;
  XYCoordinate? handledNodeCoordinate;

  PlayingPiece(this.shape, this.nodes, this.maxX, this.maxY) {
    mirrored = false;
    rotation = Rotation.R0;
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

  static PlayingPiece generate(int index) {
    return PlayingPiece.fromShape(
        Shapes.allShapes[index % Shapes.allShapes.length]);
  }

  void rotatePositive90() {
    // for (XYCoordinate node in nodes) {
    //   node.rotatePositive90();
    // }

    rotation = rotation.rotatePositive90();
  }

  void mirror() {
    mirrored = !mirrored;
  }

  void setHandledNodeCoordinate(int row, int col) {
    handledNodeCoordinate = XYCoordinate(x: col, y: row);
  }
}
