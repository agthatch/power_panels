import 'dart:async';

import 'package:card/game_internals/card/board_state.dart';
import 'package:card/game_internals/grid/battery.dart';
import 'package:card/game_internals/grid/target_tiers.dart';
import 'package:card/game_internals/panel/panel.dart';
import 'package:card/play_session/assembly/empty_station_widget.dart';
import 'package:card/play_session/farm/active_battery_widget.dart';
import 'package:flutter/material.dart';

class BatteryWarehouse {
  final int bayCount;
  final BoardState boardState;
  final List<Battery> _activeBatteries = [];
  final TargetTiers targets;
  bool _failed = false;
  bool _win = false;

  final StreamController<void> _playerChanges =
      StreamController<void>.broadcast();

  Stream<void> get playerChanges => _playerChanges.stream;

  BatteryWarehouse({
    required this.boardState,
    required this.bayCount,
    required this.targets,
  });

  get dailyCapacity => () {
        int res = 0;
        for (Battery battery in _activeBatteries) {
          res += battery.panel.storageCapacity;
        }
        return res;
      };

  int get openBayCount => bayCount - _activeBatteries.length;

  bool addPanel(Panel panel) {
    if (hasOpenBay()) {
      _activeBatteries.add(Battery(panel: panel));
      _playerChanges.add(null);
      return true;
    }
    return false;
  }

  bool removeBattery(Battery battery) {
    bool panelRemoved = _activeBatteries.remove(battery);

    if (panelRemoved) {
      _playerChanges.add(null);
    }
    return panelRemoved;
  }

  List<ActiveBatteryWidget> _getBatteries() {
    List<ActiveBatteryWidget> res = [];
    for (Battery battery in _activeBatteries) {
      res.add(ActiveBatteryWidget(
        battery: battery,
        boardState: boardState,
      ));
    }
    return res;
  }

  List<EmptyStation> _getEmptyStations() {
    List<EmptyStation> res = [];
    int startIndex = _activeBatteries.length + 1;
    for (int i = startIndex; i <= bayCount; i++) {
      res.add(EmptyStation(bayNumber: i));
    }
    return res;
  }

  List<Widget> getWidgets() {
    return [..._getBatteries(), ..._getEmptyStations()];
  }

  bool hasOpenBay() {
    return openBayCount > 0;
  }

  void incrementCharge({required int dayNumber, required int actionsPerDay}) {
    for (Battery battery in _activeBatteries) {
      battery.incrementChargeForFractionOfDay(fractionOfDay: actionsPerDay);
    }
  }

  void useCharge({required int dayNumber, required int actionsPerNight}) {
    int targetForNight = targets.getTargetForNight(dayNumber);
    double chargeToUse = targetForNight / actionsPerNight;

    for (Battery battery in _activeBatteries) {
      double availableCharge = battery.charge;
      if (chargeToUse > availableCharge) {
        battery.setCharge(0);
        chargeToUse -= availableCharge;
      } else {
        battery.useCharge(chargeToUse);
        chargeToUse = 0;
      }
    }

    if (chargeToUse > 0) {
      _failed = true;
    }
  }

  String getCurrentInfo(int dayNumber) {
    return 'Current Charge: ${_currentCharge().toStringAsFixed(1)} GWh / ${targets.getTargetForNight(dayNumber)} required';
  }

  String getChargeOverCapacity() {
    return '${_currentCharge().toStringAsFixed(1)} GWh / ${dailyCapacity()}';
  }

  int getCurrentRequirement(int dayNumber) {
    return targets.getTargetForNight(dayNumber);
  }

  double _currentCharge() {
    double currentCharge = 0;

    for (Battery battery in _activeBatteries) {
      currentCharge += battery.charge;
    }

    return currentCharge;
  }
}
