import 'dart:async';

import 'package:card/game_internals/panel/panel.dart';
import 'package:card/play_session/assembly/empty_station_widget.dart';
import 'package:card/play_session/panel_widget.dart';
import 'package:flutter/material.dart';

class SolarFarm {
  final int bayCount;
  final List<Panel> activePanels = [Panel(dimX: 5, dimY: 2)];

  final StreamController<void> _playerChanges =
      StreamController<void>.broadcast();

  Stream<void> get playerChanges => _playerChanges.stream;

  SolarFarm({
    required this.bayCount,
  });

  bool addPanel(Panel panel) {
    if (activePanels.length < bayCount) {
      activePanels.add(panel);
      _playerChanges.add(null);
      return true;
    }
    return false;
  }

  bool removePanel(Panel panel) {
    bool panelRemoved = activePanels.remove(panel);

    if (panelRemoved) {
      _playerChanges.add(null);
    }
    return panelRemoved;
  }

  List<PanelWidget> _getPuzzles() {
    List<PanelWidget> res = [];
    for (Panel panel in activePanels) {
      res.add(PanelWidget(panel: panel));
    }
    return res;
  }

  List<EmptyStation> _getEmptyStations() {
    List<EmptyStation> res = [];
    int startIndex = activePanels.length + 1;
    for (int i = startIndex; i <= bayCount; i++) {
      res.add(EmptyStation(bayNumber: i));
    }
    return res;
  }

  List<Widget> getWidgets() {
    return [..._getPuzzles(), ..._getEmptyStations()];
  }

  bool hasOpenBay() {
    return bayCount > activePanels.length;
  }
}
