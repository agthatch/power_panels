// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:card/game_internals/blueprint/blueprint.dart';
import 'package:card/game_internals/blueprint/blueprint_provider.dart';
import 'package:card/game_internals/panel/panel.dart';
import 'package:card/play_session/assembly/assembly_bay.dart';
import 'package:flutter/foundation.dart';

import 'player.dart';

class BoardState {
  final VoidCallback onWin;

  /// *What do we need in the boardState?
  /// We need the blueprint piles
  BlueprintProvider easyBlueprints;
  BlueprintProvider hardBlueprints;

  /// We need active panels
  /// We need active puzzles
  AssemblyBay assemblyBay = AssemblyBay(bayCount: 4);

  /// We need the toolbox (player hand, avaialble pieces)
  /// We also need the currently generated number
  /// We need the target numbers
  /// We need day number (round)

  final Panel panelOne = Panel(dimX: 5, dimY: 2);

  final Panel panelTwo = Panel(dimX: 6, dimY: 6);

  final Player player = Player();

  BoardState(
      {required this.onWin,
      required this.easyBlueprints,
      required this.hardBlueprints}) {
    player.addListener(_handlePlayerChange);
  }

  // List<PlayingArea> get areas => [areaOne, areaTwo];

  void dispose() {
    player.removeListener(_handlePlayerChange);
    // areaOne.dispose();
    // areaTwo.dispose();
  }

  void _handlePlayerChange() {
    if (player.hand.isEmpty) {
      onWin();
    }
  }

  bool canAddPuzzle() {
    return assemblyBay.hasOpenBay();
  }

  void purchaseBlueprint(Blueprint blueprint) {
    easyBlueprints.removeBlueprint(blueprint);
    hardBlueprints.removeBlueprint(blueprint);

    assemblyBay.addPuzzle(blueprint);
  }
}
