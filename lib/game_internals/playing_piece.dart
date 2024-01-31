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

  int get size => nodes.length;

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

  XYCoordinate getOffsetFromClickedNodeToTopLeftCorner() {
    //Find the piece node that will be in the top left corner after rotation and mirroring
    XYCoordinate topLeftWhenTransformed =
        _getTopLeftCoordinateAfterRotationAndMirroring();
    print("topLeftWhenTransformed $topLeftWhenTransformed");

    //2- translate the x and y coordinates to the agree with handledNodeCoordinate
    XYCoordinate? handledCoordinateTranformed =
        handledNodeCoordinate?.rotateCopy(rotation).mirrorXDirection();
    print("handledCoordinateTranformed $handledCoordinateTranformed");
    return topLeftWhenTransformed.negativeOffsetBy(
        handledCoordinateTranformed ?? XYCoordinate(x: 0, y: 0));
    //3- save the new x,y coordinates in `location`
  }

  XYCoordinate _getTopLeftCoordinateAfterRotationAndMirroring() {
    if (!mirrored) {
      switch (rotation) {
        case Rotation.R0:
          return XYCoordinate(x: 0, y: 0);
        case Rotation.R90:
          return XYCoordinate(x: -(maxY - 1), y: 0);
        case Rotation.R180:
          return XYCoordinate(x: -(maxX - 1), y: -(maxY - 1));
        case Rotation.R270:
          return XYCoordinate(x: 0, y: -(maxX - 1));
      }
    } else {
      switch (rotation) {
        case Rotation.R0:
          return XYCoordinate(x: -(maxX - 1), y: 0);
        case Rotation.R90:
          return XYCoordinate(x: -(maxY - 1), y: 0);
        case Rotation.R180:
          return XYCoordinate(x: 0, y: -(maxY - 1));
        case Rotation.R270:
          return XYCoordinate(x: -(maxY - 1), y: -(maxX - 1));
      }
    }
  }
}
