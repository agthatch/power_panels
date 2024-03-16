import 'dart:async';

import 'package:card/game_internals/card/board_state.dart';
import 'package:card/game_internals/piece/piece_data.dart';
import 'package:card/game_internals/piece/playing_piece.dart';
import 'package:card/game_internals/rounds/actions/action.dart';
import 'package:card/game_internals/rounds/actions/action_type.dart';
import 'package:card/game_internals/upcycling/piece_stack.dart';

class UpcycleController {
  final BoardState boardState;
  final StreamController<void> _playerChanges =
      StreamController<void>.broadcast();

  bool _visible = false;

  UpcycleController({required this.boardState}) {
    piecesToUpcycle = PieceStack(removeLastPieceCallback: (PlayingPiece piece) {
      piece.isStaged = false;
      boardState.player.addPiece(piece);
      resultingPieces.clear();
      _playerChanges.add(null);
    });
    resultingPieces = PieceStack(removeLastPieceCallback: (PlayingPiece piece) {
      _playerChanges.add(null);
    });
  }

  Stream<void> get playerChanges => _playerChanges.stream;

  late PieceStack piecesToUpcycle;
  final List<PlayingPiece> _availablePieces = [];
  late PieceStack resultingPieces;

  final List<PlayingPiece> _allPieces =
      List.generate(Shape.allShapes.length, (index) {
    PlayingPiece piece = PlayingPiece.generate(index);
    piece.isStaged = true;
    return piece;
  });

  int get discardedCellCount {
    int sum = 0;
    for (PlayingPiece piece in piecesToUpcycle.pieces) {
      sum += piece.size;
    }
    return sum;
  }

  int get resultingCellCount {
    int sum = 0;
    for (PlayingPiece piece in resultingPieces.pieces) {
      sum += piece.size;
    }
    return sum;
  }

  int get availableCellCount => discardedCellCount + 1 - resultingCellCount;

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

  bool get shouldShow => _visible;

  void addPieceToUpcycle(PlayingPiece piece) {
    piecesToUpcycle.add(piece);
    _playerChanges.add(null);
  }

  void addPieceToOutput(PlayingPiece piece) {
    resultingPieces.add(piece);
    _playerChanges.add(null);
  }

  void cancel() {
    _visible = false;
    for (PlayingPiece piece in piecesToUpcycle.pieces) {
      boardState.player.addPiece(piece);
    }

    piecesToUpcycle.clear();

    resultingPieces.clear();
    _playerChanges.add(null);
  }

  void show() {
    _visible = true;
  }

  void selectPiece(PlayingPiece piece) {
    resultingPieces.add(piece.clone());
    _playerChanges.add(null);
  }

  void completeAction() {
    List<PlayingPiece> res = resultingPieces.pieces;

    UpcycleAction action = UpcycleAction(
        actionType: ActionType.upcycledPieces,
        discardedPieces: piecesToUpcycle.pieces,
        newPieces: resultingPieces.pieces);

    boardState.actionManager.handleAction(action);
    for (PlayingPiece piece in res) {
      piece.isStaged = false;
      boardState.player.addPiece(piece);
    }
    piecesToUpcycle.clear();
    resultingPieces.clear();
  }
}
