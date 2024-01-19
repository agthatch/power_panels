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

  PlayingPiece(this.shape, this.nodes, this.maxX, this.maxY) {
    mirrored = false;
    rotation = Rotation.R0;
  }

  factory PlayingPiece.fromShape(List<List<int>> input) {
    List<XYCoordinate> nodes = [];
    List<List<bool>> shape = [];
    int i = 0;
    int j = 0;
    for (i = 0; i < input.length; i++) {
      List<bool> row = [];
      for (j = 0; j < input[i].length; j++) {
        bool isNode = input[i][j] == 1;
        row.add(isNode);
        if (isNode) {
          nodes.add(XYCoordinate(x: i, y: j));
        }
      }
      shape.add(row);
    }

    return PlayingPiece(shape, nodes, j, i);
  }

  static PlayingPiece generate(int index) {
    return PlayingPiece.fromShape(
        Shapes.allShapes[index % Shapes.allShapes.length]);
  }

  void rotatePositive90() {
    for (XYCoordinate node in nodes) {
      node.rotatePositive90();
    }
  }
}
