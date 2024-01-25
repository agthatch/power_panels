import 'package:card/game_internals/rotation.dart';

class XYCoordinate {
  int x;
  int y;

  XYCoordinate({required this.x, required this.y});

  void rotate(Rotation degree) {
    switch (degree) {
      case Rotation.R0:
        break;
      case Rotation.R90:
        int prevX = x;
        int prevY = y;

        x = -prevY;
        y = prevX;
        break;
      case Rotation.R180:
        int prevX = x;
        int prevY = y;

        x = -prevX;
        y = -prevY;

        break;
      case Rotation.R270:
        int prevX = x;
        int prevY = y;

        x = prevY;
        y = -prevX;
        break;
    }
  }

  void rotatePositive90() {
    rotate(Rotation.R90);
  }

  void rotateNegative90() {
    rotate(Rotation.R270);
  }

  void mirrorXDirection() {
    x = -x;
  }

  XYCoordinate offsetBy(XYCoordinate offset) {
    return XYCoordinate(x: x + offset.x, y: y + offset.y);
  }

  XYCoordinate negativeOffsetBy(XYCoordinate offset) {
    return XYCoordinate(x: x - offset.x, y: y - offset.y);
  }

  @override
  String toString() {
    return 'XYCoordinate{x: $x, y: $y}';
  }
}
