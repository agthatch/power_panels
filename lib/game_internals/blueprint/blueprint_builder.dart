import 'package:card/game_internals/blueprint/blueprint.dart';
import 'package:card/game_internals/piece/placed_piece.dart';

class BlueprintBuilder {
  int xDim = 5;
  int yDim = 5;
  int storageCapacity = 5;
  List<PlacedPiece> preFitPieces = [];

  Blueprint build() {
    return Blueprint(
        xDim: xDim,
        yDim: yDim,
        storageCapacity: storageCapacity,
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

  BlueprintBuilder withStorageCapacity(int storageCapacity) {
    this.storageCapacity = storageCapacity;
    return this;
  }

  BlueprintBuilder withPrefitPiece(PlacedPiece placedPiece) {
    preFitPieces.add(placedPiece);
    return this;
  }
}
