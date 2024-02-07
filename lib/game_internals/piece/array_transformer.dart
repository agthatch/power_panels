class ArrayTransformer {
  static List<List<bool>> rotateShapeClockwise(List<List<bool>> shape) {
    int rows = shape.length;
    int columns = shape[0].length;

    List<List<bool>> rotatedMatrix =
        List.generate(columns, (index) => List<bool>.filled(rows, false));

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        rotatedMatrix[j][rows - 1 - i] = shape[i][j];
      }
    }

    return rotatedMatrix;
  }

  static List<List<bool>> mirrorAboutX(List<List<bool>> shape) {
    int rows = shape.length;
    int columns = shape[0].length;

    List<List<bool>> mirrored =
        List.generate(rows, (index) => List<bool>.filled(columns, false));

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        mirrored[i][columns - 1 - j] = shape[i][j];
      }
    }

    return mirrored;
  }
}
