class Shapes {
  static const List<List<int>> single = [
    [1]
  ];
  static const List<List<int>> lineTwo = [
    [1],
    [1]
  ];
  static const List<List<int>> lineThree = [
    [1],
    [1],
    [1]
  ];
  static const List<List<int>> corner = [
    [0, 1],
    [1, 1]
  ];
  static const List<List<int>> square = [
    [1, 1],
    [1, 1]
  ];
  static const List<List<int>> T = [
    [1, 0],
    [1, 1],
    [1, 0]
  ];
  static const List<List<int>> Z = [
    [0, 1],
    [1, 1],
    [1, 0]
  ];
  static const List<List<int>> L = [
    [1, 0],
    [1, 0],
    [1, 1]
  ];
  static const List<List<int>> lineFour = [
    [1],
    [1],
    [1],
    [1]
  ];

  static const List<List<List<int>>> allShapes = [
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
}
