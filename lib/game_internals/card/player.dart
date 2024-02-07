import 'package:card/game_internals/piece/playing_piece.dart';
import 'package:flutter/foundation.dart';

class Player extends ChangeNotifier {
  static const maxCards = 20;

  final List<PlayingPiece> hand =
      List.generate(maxCards, (index) => PlayingPiece.generate(index));

  void removePiece(PlayingPiece piece) {
    hand.remove(piece);
    notifyListeners();
  }
}
