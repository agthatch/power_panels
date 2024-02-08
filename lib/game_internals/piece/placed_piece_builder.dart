import 'package:card/game_internals/piece/piece_data.dart';
import 'package:card/game_internals/piece/placed_piece.dart';
import 'package:card/game_internals/piece/playing_piece.dart';
import 'package:card/game_internals/rotation.dart';
import 'package:card/game_internals/xy_coordinate.dart';

class PlacedPieceBuilder {
  XYCoordinate location = XYCoordinate(x: 0, y: 0);
  bool accepted = true;

  Shape shape = Shape.L;
  bool mirrored = false;
  bool isPlaced = false;
  Rotation rotation = Rotation.R0;

  PlacedPiece build() {
    PlayingPiece piece = PlayingPiece.fromShape(shape);
    piece.rotate(rotation);
    piece.mirrored = mirrored;
    if (mirrored) {
      piece.mirror();
    }

    piece.isPlaced = isPlaced;

    ///We need to transform the piece based on these settings here in the build
    return PlacedPiece(piece: piece, location: location, accepted: accepted);
  }

  PlacedPieceBuilder withLocation({required int x, required int y}) {
    location = XYCoordinate(x: x, y: y);
    return this;
  }

  PlacedPieceBuilder withAccepted(bool accepted) {
    this.accepted = accepted;
    return this;
  }

  PlacedPieceBuilder withShape(Shape shape) {
    this.shape = shape;
    return this;
  }

  PlacedPieceBuilder withMirrored(bool mirrored) {
    this.mirrored = mirrored;
    return this;
  }

  PlacedPieceBuilder withIsPlaced(bool isPlaced) {
    this.isPlaced = isPlaced;
    return this;
  }

  PlacedPieceBuilder withRotation(Rotation rotation) {
    this.rotation = rotation;
    return this;
  }
}
