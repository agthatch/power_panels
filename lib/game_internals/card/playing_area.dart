import 'dart:async';

import 'package:async/async.dart';
import 'package:card/game_internals/playing_piece.dart';

class PlayingArea {
  /// The maximum number of cards in this playing area.
  static const int maxCards = 6;

  /// The current cards in this area.
  final List<PlayingPiece> pieces = [];

  final StreamController<void> _playerChanges =
      StreamController<void>.broadcast();

  final StreamController<void> _remoteChanges =
      StreamController<void>.broadcast();

  PlayingArea();

  /// A [Stream] that fires an event every time any change to this area is made.
  Stream<void> get allChanges =>
      StreamGroup.mergeBroadcast([remoteChanges, playerChanges]);

  /// A [Stream] that fires an event every time a change is made _locally_,
  /// by the player.
  Stream<void> get playerChanges => _playerChanges.stream;

  /// A [Stream] that fires an event every time a change is made _remotely_,
  /// by another player.
  Stream<void> get remoteChanges => _remoteChanges.stream;

  /// Accepts the [piece] into the area.
  void acceptPiece(PlayingPiece piece) {
    pieces.add(piece);
    _maybeTrim();
    _playerChanges.add(null);
  }

  void dispose() {
    _remoteChanges.close();
    _playerChanges.close();
  }

  /// Removes the first card in the area, if any.
  void removeFirstCard() {
    if (pieces.isEmpty) return;
    pieces.removeAt(0);
    _playerChanges.add(null);
  }

  /// Replaces the cards in the area with [pieces].
  ///
  /// This method is meant to be called when the cards are updated from
  /// a server.
  void replaceWith(List<PlayingPiece> pieces) {
    this.pieces.clear();
    this.pieces.addAll(pieces);
    _maybeTrim();
    _remoteChanges.add(null);
  }

  void _maybeTrim() {
    if (pieces.length > maxCards) {
      pieces.removeRange(0, pieces.length - maxCards);
    }
  }
}
