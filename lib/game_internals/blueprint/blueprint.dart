import 'package:card/game_internals/piece/placed_piece.dart';
import 'package:uuid/uuid.dart';

class Blueprint {
  static final Uuid uuid = Uuid();
  final int xDim;
  final int yDim;
  final int generationValue;
  final List<PlacedPiece> preFitPieces;
  final String id = uuid.v4();

  Blueprint(
      {required this.xDim,
      required this.yDim,
      required this.generationValue,
      required this.preFitPieces});
}
