import 'package:card/game_internals/piece/playing_piece.dart';

typedef RemoveLastPieceCallBack = void Function(PlayingPiece piece);

class PieceStack {
  final RemoveLastPieceCallBack removeLastPieceCallback;
  final List<PlayingPiece> pieces = [];

  PieceStack({required this.removeLastPieceCallback});

  void add(PlayingPiece piece) {
    pieces.add(piece);
  }

  void clear() {
    pieces.clear();
  }

  void removeLastPiece() {
    if (pieces.isEmpty) {
      return;
    }
    PlayingPiece piece = pieces.removeLast();
    removeLastPieceCallback(piece);
  }
}
