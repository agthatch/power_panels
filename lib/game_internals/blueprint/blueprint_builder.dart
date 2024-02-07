import 'package:card/game_internals/blueprint/blueprint.dart';
import 'package:card/game_internals/piece/placed_piece.dart';

class BlueprintBuilder {
  int xDim = 5;
  int yDim = 5;
  int generationValue = 5;
  List<PlacedPiece> preFitPieces = [];

  Blueprint build() {
    return Blueprint(
        xDim: xDim,
        yDim: yDim,
        generationValue: generationValue,
        preFitPieces: preFitPieces);
  }

  BlueprintBuilder withXDim(int xDim) {
    this.xDim = xDim;
    return this;
  }

  BlueprintBuilder withYDim(int yDim) {
    this.yDim = yDim;
    return this;
  }

  BlueprintBuilder withGenerationValue(int generationValue) {
    this.generationValue = generationValue;
    return this;
  }

  BlueprintBuilder withPrefitPiece(PlacedPiece placedPiece) {
    preFitPieces.add(placedPiece);
    return this;
  }
}
