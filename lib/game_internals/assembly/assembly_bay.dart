import 'dart:async';

import 'package:card/game_internals/blueprint/blueprint.dart';
import 'package:card/game_internals/panel/panel.dart';
import 'package:card/play_session/assembly/empty_station_widget.dart';
import 'package:card/play_session/panel_widget.dart';
import 'package:flutter/material.dart';

class AssemblyBay {
  final int bayCount;
  final List<Panel> activePuzzles = [Panel(dimX: 5, dimY: 2)];

  final StreamController<void> _playerChanges =
      StreamController<void>.broadcast();

  Stream<void> get playerChanges => _playerChanges.stream;

  AssemblyBay({
    required this.bayCount,
  });

  bool addPuzzle(Blueprint blueprint) {
    if (activePuzzles.length < bayCount) {
      activePuzzles.add(Panel.fromBlueprint(blueprint));
      _playerChanges.add(null);
      return true;
    }
    return false;
  }

  void removePuzzle(Panel panel) {
    bool puzzleRemoved = activePuzzles.remove(panel);

    if (puzzleRemoved) {
      _playerChanges.add(null);
    }
  }

  List<PanelWidget> _getPuzzles() {
    List<PanelWidget> res = [];
    for (Panel panel in activePuzzles) {
      res.add(PanelWidget(panel: panel));
    }
    return res;
  }

  List<EmptyStation> _getEmptyStations() {
    List<EmptyStation> res = [];
    int startIndex = activePuzzles.length + 1;
    for (int i = startIndex; i <= bayCount; i++) {
      res.add(EmptyStation(bayNumber: i));
    }
    return res;
  }

  List<Widget> getWidgets() {
    return [..._getPuzzles(), ..._getEmptyStations()];
  }

  bool hasOpenBay() {
    return bayCount > activePuzzles.length;
  }
}
