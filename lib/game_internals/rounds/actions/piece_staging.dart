import 'dart:async';

import 'package:card/game_internals/rounds/actions/staged_piece.dart';

class PieceStaging {
  final List<StagedPiece> _stagedPieces = [];

  int get countOfStagedPieces => _stagedPieces.length;

  final StreamController<void> _playerChanges =
      StreamController<void>.broadcast();

  Stream<void> get playerChanges => _playerChanges.stream;

  void handleStagedPiece(StagedPiece stagedPiece) {
    _stagedPieces.add(stagedPiece);
    _playerChanges.add(null);
  }

  bool placePieceActionIsAvailable() {
    return countOfStagedPieces == 1;
  }

  bool efficientActionIsAvailable() {
    return countOfStagedPieces > 1;
  }

  bool unstageActionIsAvailable() {
    return _stagedPieces.isNotEmpty;
  }

  void processEfficientAction() {
    //TODO: implement Efficient Action
    _playerChanges.add(null);
  }

  void unstagePieces() {
    //TODO: implement Unstage Action
    _playerChanges.add(null);
  }

  void processPlacePieceAction() {
    //TODO: implement Place Piece Action
    _playerChanges.add(null);
  }
}
