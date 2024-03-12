import 'dart:async';

import 'package:card/game_internals/card/board_state.dart';
import 'package:card/game_internals/rounds/actions/action.dart';
import 'package:card/game_internals/rounds/actions/action_type.dart';
import 'package:card/game_internals/rounds/round.dart';
import 'package:card/game_internals/rounds/shift_tracker.dart';
import 'package:card/game_internals/warehouse/battery_warehouse.dart';

class ActionManager {
  final int dayRounds;
  final int nightRounds;
  final List<Round> _rounds = [];
  final BoardState _boardState;
  late ShiftTracker _shiftTracker;
  final BatteryWarehouse warehouse;

  late Round _currentRound;

  final StreamController<void> _playerChanges =
      StreamController<void>.broadcast();

  Stream<void> get playerChanges => _playerChanges.stream;

  ActionManager(this._boardState,
      {required this.dayRounds,
      required this.nightRounds,
      required this.warehouse}) {
    _shiftTracker =
        ShiftTracker(dayActions: dayRounds, nightActions: nightRounds);
    updateCurrentRound();
  }

  bool get isDay => _shiftTracker.isDay();

  int get dayNumber => _shiftTracker.dayNumber;

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
      if (_shiftTracker.isDay()) {
        warehouse.incrementCharge(
            dayNumber: _shiftTracker.dayNumber,
            actionsPerDay: _shiftTracker.dayActions);
      } else {
        warehouse.useCharge(
            dayNumber: _shiftTracker.dayNumber,
            actionsPerNight: _shiftTracker.nightActions);
      }
      _shiftTracker.advanceAction();
    }

    ///Check for win/lose
    if (warehouse.winConditionMet) {
      _boardState.triggerWin();
    } else if (warehouse.failed) {
      _boardState.triggerFailure();
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
