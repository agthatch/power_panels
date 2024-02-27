import 'dart:async';

import 'package:card/game_internals/card/board_state.dart';
import 'package:card/game_internals/rounds/actions/action.dart';
import 'package:card/game_internals/rounds/actions/action_type.dart';
import 'package:card/game_internals/rounds/round.dart';

class RoundManager {
  final int actionsPerRound;
  final List<Round> _rounds = [];
  final BoardState _boardState;
  int _currentRoundNumber = 0;

  final StreamController<void> _playerChanges =
      StreamController<void>.broadcast();

  Stream<void> get playerChanges => _playerChanges.stream;

  RoundManager(this._boardState, {required this.actionsPerRound}) {
    _rounds.add(Round(roundNumber: 0, actionsPerRound: actionsPerRound));
  }

  get roundDisplayString => _currentRoundNumber + 1;

  bool currentRoundComplete() {
    Round currentRound = _getCurrentRound();
    return currentRound.isComplete();
  }

  Round _getCurrentRound() {
    return _getRound(_currentRoundNumber);
  }

  Round _getRound(int roundNumber) {
    if (_rounds.length == roundNumber) {
      Round newRound =
          Round(roundNumber: roundNumber, actionsPerRound: actionsPerRound);
      _rounds.add(newRound);
    }
    return _rounds[roundNumber];
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
      _incrementRound();
    }

    _playerChanges.add(null);
  }

  String getRoundInfo() {
    return 'Round: $roundDisplayString Actions: ${_getCurrentRound().getActionCount()}/$actionsPerRound';
  }

  Stream getChangeStream() {
    return playerChanges;
  }

  bool currentRoundHasUsedEfficientAction() {
    return _getCurrentRound().efficientActionHasBeenUsed;
  }

  void _incrementRound() {
    _currentRoundNumber++;
    _boardState.handleRoundIncremented();
  }
}
