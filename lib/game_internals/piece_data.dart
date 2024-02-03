import 'package:card/game_internals/xy_coordinate.dart';

enum Shape {
  single([
    [1]
  ]),
  lineTwo([
    [1],
    [1]
  ]),
  lineThree([
    [1],
    [1],
    [1]
  ]),
  corner([
    [0, 1],
    [1, 1]
  ]),
  square([
    [1, 1],
    [1, 1]
  ]),
  T([
    [1, 0],
    [1, 1],
    [1, 0]
  ]),
  Z([
    [0, 1],
    [1, 1],
    [1, 0]
  ]),
  L([
    [1, 0],
    [1, 0],
    [1, 1]
  ]),
  lineFour([
    [1],
    [1],
    [1],
    [1]
  ]);

  const Shape(this.representation);
  final List<List<int>> representation;

  static const List<Shape> allShapes = [
    single,
    lineTwo,
    lineThree,
    corner,
    square,
    T,
    Z,
    L,
    lineFour
  ];

  List<List<bool>> asBools() {
    List<List<bool>> shapeAsBools = [];
    int y = 0;
    int x = 0;
    for (y = 0; y < representation.length; y++) {
      List<bool> row = [];
      for (x = 0; x < representation[y].length; x++) {
        bool isNode = representation[y][x] == 1;
        row.add(isNode);
      }
      shapeAsBools.add(row);
    }
    return shapeAsBools;
  }

  List<XYCoordinate> getNodes() {
    List<XYCoordinate> nodes = [];
    List<List<bool>> bools = asBools();
    int y = 0;
    int x = 0;
    for (y = 0; y < bools.length; y++) {
      for (x = 0; x < bools[y].length; x++) {
        bool isNode = bools[y][x];
        if (isNode) {
          nodes.add(XYCoordinate(x: x, y: y));
        }
      }
    }

    return nodes;
  }

  int maxX() {
    return representation[0].length;
  }

  int maxY() {
    return representation.length;
  }
}
