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

  PlacedPieceAction(
      {required this.piece,
      required this.receiveingPanel,
      required this.placedLocation,
      super.actionType = ActionType.placedPiece});
}

class EfficientAction extends Action {
  final List<PlacedPieceAction> actions;

  EfficientAction(
      {required this.actions, super.actionType = ActionType.efficientAction});
}

class BoughtBlueprintAction extends Action {
  final Blueprint originalBlueprint;
  final Panel resultingPanel;

  BoughtBlueprintAction(
      {super.actionType = ActionType.boughtBlueprint,
      required this.originalBlueprint,
      required this.resultingPanel});
}

class RecycledPanelAction extends Action {
  final Panel panel;

  RecycledPanelAction(
      {super.actionType = ActionType.recycledPanel, required this.panel});
}
