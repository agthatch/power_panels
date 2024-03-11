class ShiftTracker {
  final int dayActions;
  final int nightActions;
  int _currentActionCount = 0;

  ShiftTracker({this.dayActions = 3, this.nightActions = 3});

  int get currentRoundNumber => isDay() ? _dayNumber * 2 : (_dayNumber * 2 + 1);

  get _shiftTypeString => isDay() ? 'Day' : 'Night';

  int get _actionInShift => isDay()
      ? _getActionNumberForCurrentDay()
      : (_getActionNumberForCurrentDay() - dayActions);

  int get actionLimitForCurrentShift => isDay() ? dayActions : nightActions;

  void advanceAction() {
    _currentActionCount++;
  }

  int get _dayNumber => _currentActionCount ~/ _actionsPerDay;

  int get _displayDayNumber => 1 + _dayNumber;

  int get _actionsPerDay => dayActions + nightActions;

  int _getActionNumberForCurrentDay() {
    return _currentActionCount % _actionsPerDay;
  }

  bool isDay() {
    return _getActionNumberForCurrentDay() < dayActions;
  }

  String getShiftInfoString() {
    return '$_shiftTypeString $_displayDayNumber - Completed Tasks: $_actionInShift/$actionLimitForCurrentShift';
  }
}
