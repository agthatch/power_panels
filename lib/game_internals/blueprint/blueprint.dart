import 'package:card/game_internals/piece/placed_piece.dart';

class Blueprint {
  final int xDim;
  final int yDim;
  final int generationValue;
  final List<PlacedPiece> preFitPieces;

  Blueprint(
      {required this.xDim,
      required this.yDim,
      required this.generationValue,
      required this.preFitPieces});
}
