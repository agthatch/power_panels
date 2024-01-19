class XYCoordinate {
  int x;
  int y;

  XYCoordinate({required this.x, required this.y});

  void rotatePositive90() {
    int prevX = x;
    int prevY = y;

    x = -prevY;
    y = prevX;
  }

  void rotateNegative90() {
    int prevX = x;
    int prevY = y;

    x = prevY;
    y = -prevX;
  }

  void mirrorXDirection() {
    x = -x;
  }
}
