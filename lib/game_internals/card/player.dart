import 'package:card/game_internals/piece/playing_piece.dart';
import 'package:flutter/foundation.dart';

class Player extends ChangeNotifier {
  static const startingPieceCount = 20;
  bool _expandHand = false;

  final List<PlayingPiece> hand = List.generate(
      startingPieceCount, (index) => PlayingPiece.generate(index));

  bool get handIsExpanded => _expandHand;

  void removePiece(PlayingPiece piece) {
    hand.remove(piece);
    notifyListeners();
  }

  void addPiece(PlayingPiece piece) {
    hand.add(piece);
    notifyListeners();
  }

  void toggleHandExpand() {
    _expandHand = !_expandHand;
    notifyListeners();
  }

  void externalNotifyListnerCall() {
    notifyListeners();
  }
}
