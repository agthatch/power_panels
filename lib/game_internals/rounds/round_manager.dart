import 'package:card/game_internals/rounds/actions/action.dart';
import 'package:card/game_internals/rounds/actions/action_type.dart';
import 'package:card/game_internals/rounds/round.dart';

class RoundManager {
  final int actionsPerRound;
  final List<Round> _rounds = [];
  int _currentRoundNumber = 0;

  RoundManager({required this.actionsPerRound}) {
    _rounds.add(Round(roundNumber: 0, actionsPerRound: actionsPerRound));
  }

  bool currentRoundComplete() {
    Round currentRound = _getCurrentRound();
    return currentRound.isComplete();
  }

  Round _getCurrentRound() {
    Round currentRound = _rounds[_currentRoundNumber];
    return currentRound;
  }

  bool currentRoundCanAcceptActionType(ActionType type) {
    Round currentRound = _getCurrentRound();
    return currentRound.canAcceptActionType(type);
  }

  void handleAction(Action action) {
    if (currentRoundCanAcceptActionType(action.actionType)) {
      _getCurrentRound().handleAction(action);
    }

    if (currentRoundComplete()) {
      _currentRoundNumber++;
    }
  }
}
