import 'package:card/game_internals/card/player.dart';
import 'package:card/game_internals/panel/panel.dart';
import 'package:card/game_internals/piece/placed_piece.dart';

class StagedPiece {
  final PlacedPiece piece;
  final Panel panel;
  final Player player;

  StagedPiece({required this.piece, required this.panel, required this.player});
}
