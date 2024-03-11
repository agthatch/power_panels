import 'dart:async';

import 'package:card/game_internals/card/board_state.dart';
import 'package:card/game_internals/panel/panel.dart';
import 'package:card/play_session/assembly/empty_station_widget.dart';
import 'package:card/play_session/farm/solar_panel_widget.dart';
import 'package:flutter/material.dart';

class BatteryWarehouse {
  final int bayCount;
  final BoardState boardState;
  final List<Panel> _activePanels = [];

  final StreamController<void> _playerChanges =
      StreamController<void>.broadcast();

  Stream<void> get playerChanges => _playerChanges.stream;

  BatteryWarehouse({
    required this.boardState,
    required this.bayCount,
  });

  get dailyCapacity => () {
        int res = 0;
        for (Panel panel in _activePanels) {
          res += panel.storageCapacity;
        }
        return res;
      };

  int get openBayCount => bayCount - _activePanels.length;

  bool addPanel(Panel panel) {
    if (hasOpenBay()) {
      _activePanels.add(panel);
      _playerChanges.add(null);
      return true;
    }
    return false;
  }

  bool removePanel(Panel panel) {
    bool panelRemoved = _activePanels.remove(panel);

    if (panelRemoved) {
      _playerChanges.add(null);
    }
    return panelRemoved;
  }

  List<ActiveBatteryWidget> _getPannels() {
    List<ActiveBatteryWidget> res = [];
    for (Panel panel in _activePanels) {
      res.add(ActiveBatteryWidget(
        panel: panel,
        boardState: boardState,
      ));
    }
    return res;
  }

  List<EmptyStation> _getEmptyStations() {
    List<EmptyStation> res = [];
    int startIndex = _activePanels.length + 1;
    for (int i = startIndex; i <= bayCount; i++) {
      res.add(EmptyStation(bayNumber: i));
    }
    return res;
  }

  List<Widget> getWidgets() {
    return [..._getPannels(), ..._getEmptyStations()];
  }

  bool hasOpenBay() {
    return openBayCount > 0;
  }
}
