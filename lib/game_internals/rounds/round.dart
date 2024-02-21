import 'package:card/game_internals/rounds/actions/action.dart';
import 'package:card/game_internals/rounds/actions/action_type.dart';

class Round {
  final int roundNumber;
  final int actionsPerRound;
  bool _roundComplete = false;
  bool _efficientActionHasBeenUsed = false;

  List<Action> actionHistory = [];

  Round({required this.roundNumber, required this.actionsPerRound});

  bool canAcceptActionType(ActionType type) {
    if (_roundComplete) {
      return false;
    }

    if (actionHistory.length >= actionsPerRound) {
      return false;
    }

    if (_efficientActionHasBeenUsed && type == ActionType.efficientAction) {
      return false;
    }

    return true;
  }

  void handleAction(Action action) {
    actionHistory.add(action);
    if (action.actionType == ActionType.efficientAction) {
      _efficientActionHasBeenUsed = true;
    }

    if (actionHistory.length >= actionsPerRound) {
      _roundComplete = true;
    }
  }

  bool isComplete() {
    return _roundComplete;
  }

  int getActionCount() {
    return actionHistory.length;
  }
}
