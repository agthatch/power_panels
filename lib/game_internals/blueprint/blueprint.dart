import 'package:card/game_internals/piece/placed_piece.dart';
import 'package:uuid/uuid.dart';

class Blueprint {
  static final Uuid uuid = Uuid();
  final int xDim;
  final int yDim;
  final int storageCapacity;
  final List<PlacedPiece> preFitPieces;
  final String id = uuid.v4();

  Blueprint(
      {required this.xDim,
      required this.yDim,
      required this.storageCapacity,
      required this.preFitPieces});
}
