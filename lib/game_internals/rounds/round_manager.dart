import 'dart:async';

import 'package:card/game_internals/card/board_state.dart';
import 'package:card/game_internals/rounds/actions/action.dart';
import 'package:card/game_internals/rounds/actions/action_type.dart';
import 'package:card/game_internals/rounds/round.dart';
import 'package:card/game_internals/rounds/shift_tracker.dart';

class ActionManager {
  final int dayRounds;
  final int nightRounds;
  final List<Round> _rounds = [];
  final BoardState _boardState;
  late ShiftTracker _shiftTracker;

  late Round _currentRound;

  final StreamController<void> _playerChanges =
      StreamController<void>.broadcast();

  Stream<void> get playerChanges => _playerChanges.stream;

  ActionManager(this._boardState,
      {required this.dayRounds, required this.nightRounds}) {
    _shiftTracker =
        ShiftTracker(dayActions: dayRounds, nightActions: nightRounds);
    updateCurrentRound();
  }

  bool get isDay => _shiftTracker.isDay();

  bool currentRoundComplete() {
    return _currentRound.isComplete();
  }

  void updateCurrentRound() {
    int roundNumber = _shiftTracker.currentRoundNumber;
    if (_rounds.length == roundNumber) {
      Round newRound = Round(
          roundNumber: roundNumber,
          actionsPerRound: _shiftTracker.actionLimitForCurrentShift);
      _rounds.add(newRound);
      _incrementShift();
    }
    _currentRound = _rounds[roundNumber];
  }

  bool currentRoundCanAcceptActionType(ActionType type) {
    Round currentRound = _currentRound;
    return currentRound.canAcceptActionType(type);
  }

  void handleAction(Action action) {
    if (currentRoundCanAcceptActionType(action.actionType)) {
      _currentRound.handleAction(action);
      _shiftTracker.advanceAction();
    }

    updateCurrentRound();
    _playerChanges.add(null);
  }

  String getShiftInfo() {
    return _shiftTracker.getShiftInfoString();
  }

  Stream getChangeStream() {
    return playerChanges;
  }

  bool currentRoundHasUsedEfficientAction() {
    return _currentRound.efficientActionHasBeenUsed;
  }

  void _incrementShift() {
    _boardState.handleShiftIncremented();
  }
}
