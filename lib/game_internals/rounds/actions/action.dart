import 'package:card/game_internals/blueprint/blueprint.dart';
import 'package:card/game_internals/panel/panel.dart';
import 'package:card/game_internals/piece/playing_piece.dart';
import 'package:card/game_internals/rounds/actions/action_type.dart';
import 'package:card/game_internals/xy_coordinate.dart';

abstract class Action {
  final ActionType actionType;

  Action({required this.actionType});
}

class PlacedPieceAction extends Action {
  final PlayingPiece piece;
  final Panel receiveingPanel;
  final XYCoordinate placedLocation;

  PlacedPieceAction(this.piece, this.receiveingPanel, this.placedLocation,
      {super.actionType = ActionType.placedPiece});
}

class BoughtBlueprintAction extends Action {
  final Blueprint originalBlueprint;
  final Panel resultingPanel;

  BoughtBlueprintAction(
      {super.actionType = ActionType.boughtBlueprint,
      required this.originalBlueprint,
      required this.resultingPanel});
}
