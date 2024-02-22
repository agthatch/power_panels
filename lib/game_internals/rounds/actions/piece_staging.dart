import 'package:card/game_internals/rounds/actions/staged_piece.dart';

class PieceStaging {
  final List<StagedPiece> _stagedPieces = [];

  void handleStagedPiece(StagedPiece stagedPiece) {
    _stagedPieces.add(stagedPiece);
  }
}
