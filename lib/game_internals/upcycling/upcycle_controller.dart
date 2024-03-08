import 'dart:async';

import 'package:card/game_internals/card/board_state.dart';
import 'package:card/game_internals/piece/piece_data.dart';
import 'package:card/game_internals/piece/playing_piece.dart';

class UpcycleController {
  final BoardState _boardState;
  final StreamController<void> _playerChanges =
      StreamController<void>.broadcast();

  UpcycleController({required BoardState boardState})
      : _boardState = boardState;

  Stream<void> get playerChanges => _playerChanges.stream;

  final List<PlayingPiece> _piecesToUpcycle = [];
  final List<PlayingPiece> _availablePieces = [];
  final List<PlayingPiece> _resultingPieces = [];

  final List<PlayingPiece> _allPieces = List.generate(
      Shape.allShapes.length, (index) => PlayingPiece.generate(index));

  int get discardedCellCount {
    int sum = 0;
    for (PlayingPiece piece in _piecesToUpcycle) {
      sum += piece.size;
    }
    return sum;
  }

  int get resultingCellCount {
    int sum = 0;
    for (PlayingPiece piece in _resultingPieces) {
      sum += piece.size;
    }
    return sum;
  }

  int get availableCellCount => discardedCellCount + 1;

  bool get canCacheOut => resultingCellCount == availableCellCount;

  List<PlayingPiece> get potentialPieces {
    _availablePieces.clear();
    int cellCount = availableCellCount;

    for (PlayingPiece piece in _allPieces) {
      if (piece.size <= cellCount) {
        _availablePieces.add(piece);
      }
    }

    return _availablePieces;
  }

  void addPieceToUpcycle(PlayingPiece piece) {
    _piecesToUpcycle.add(piece);
    _playerChanges.add(null);
  }

  void addPieceToOutput(PlayingPiece piece) {
    _resultingPieces.add(piece);
    _playerChanges.add(null);
  }

  List<PlayingPiece> getFinalizedOutput() {
    if (!canCacheOut) {
      return [];
    }

    List<PlayingPiece> res = _resultingPieces;
    _piecesToUpcycle.clear();
    _resultingPieces.clear();
    _playerChanges.add(null);
    return res;
  }
}
