// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:card/game_internals/blueprint/blueprint.dart';
import 'package:card/game_internals/blueprint/blueprint_provider.dart';
import 'package:card/game_internals/farm/solar_farm.dart';
import 'package:card/game_internals/panel/panel.dart';
import 'package:card/game_internals/assembly/assembly_bay.dart';
import 'package:card/game_internals/rounds/actions/action.dart';
import 'package:card/game_internals/rounds/actions/action_type.dart';
import 'package:card/game_internals/rounds/actions/piece_staging.dart';
import 'package:card/game_internals/rounds/actions/staged_piece.dart';
import 'package:card/game_internals/rounds/round_manager.dart';
import 'package:flutter/foundation.dart';

import 'player.dart';

class BoardState {
  final VoidCallback onWin;

  /// *What do we need in the boardState?
  /// We need the round manager
  RoundManager roundManager;

  /// We need the blueprint piles
  BlueprintProvider easyBlueprints;
  BlueprintProvider hardBlueprints;

  /// We need active panels
  late SolarFarm solarFarm;

  /// We need active puzzles
  AssemblyBay assemblyBay = AssemblyBay(bayCount: 4);

  /// We need staged Pieces
  late PieceStaging pieceStaging;

  /// We need the toolbox (player hand, avaialble pieces)
  /// We also need the currently generated number
  /// We need the target numbers

  final Player player = Player();

  BoardState(
      {required this.onWin,
      required this.roundManager,
      required this.easyBlueprints,
      required this.hardBlueprints}) {
    player.addListener(_handlePlayerChange);
    pieceStaging = PieceStaging(boardState: this);
    solarFarm = SolarFarm(boardState: this, bayCount: 2);
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
    return assemblyBay.hasOpenBay() && !roundManager.currentRoundComplete();
  }

  void purchaseBlueprint(Blueprint blueprint) {
    if (roundManager
        .currentRoundCanAcceptActionType(ActionType.boughtBlueprint)) {
      Panel? resultingPanel = assemblyBay.addPuzzle(blueprint);

      if (resultingPanel != null) {
        easyBlueprints.removeBlueprint(blueprint);
        hardBlueprints.removeBlueprint(blueprint);

        roundManager.handleAction(BoughtBlueprintAction(
            originalBlueprint: blueprint, resultingPanel: resultingPanel));
      }
    }
  }

  void handleStagedPiece(StagedPiece stagedPiece) {
    pieceStaging.handleStagedPiece(stagedPiece);
  }

  void recycleSolarPanel(Panel panel) {
    print('Should be recycling panel');
  }

  void handleCompletedPuzzle(Panel panel) {
    print('boardState sees puzzle complete');
    if (solarFarm.addPanel(panel)) {
      assemblyBay.removePuzzle(panel);
    }
  }
}
