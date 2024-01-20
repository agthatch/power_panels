// ignore_for_file: constant_identifier_names

enum Rotation {
  R0,
  R90,
  R180,
  R270;

  Rotation rotatePositive90() {
    switch (this) {
      case Rotation.R0:
        return R90;
      case Rotation.R90:
        return R180;
      case Rotation.R180:
        return R270;
      case Rotation.R270:
        return R0;
    }
  }

  Rotation rotateNegative90() {
    switch (this) {
      case Rotation.R0:
        return R270;
      case Rotation.R90:
        return R0;
      case Rotation.R180:
        return R90;
      case Rotation.R270:
        return R180;
    }
  }

  double degrees() {
    switch (this) {
      case Rotation.R0:
        return 0.0;
      case Rotation.R90:
        return 90.0;
      case Rotation.R180:
        return 180.0;
      case Rotation.R270:
        return 270.0;
    }
  }
}
