// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:card/game_internals/blueprint/blueprint.dart';
import 'package:card/game_internals/blueprint/blueprint_provider.dart';
import 'package:card/game_internals/grid/battery.dart';
import 'package:card/game_internals/grid/target_tiers.dart';
import 'package:card/game_internals/warehouse/battery_warehouse.dart';
import 'package:card/game_internals/panel/panel.dart';
import 'package:card/game_internals/assembly/assembly_bay.dart';
import 'package:card/game_internals/piece/placed_piece.dart';
import 'package:card/game_internals/rounds/actions/action.dart';
import 'package:card/game_internals/rounds/actions/action_type.dart';
import 'package:card/game_internals/rounds/actions/piece_staging.dart';
import 'package:card/game_internals/rounds/actions/staged_piece.dart';
import 'package:card/game_internals/rounds/action_manager.dart';
import 'package:card/game_internals/upcycling/upcycle_controller.dart';
import 'package:flutter/foundation.dart';

import 'player.dart';

class BoardState {
  final VoidCallback onWin;
  final VoidCallback onLoss;

  /// *What do we need in the boardState?
  /// We need the round manager
  late ActionManager actionManager;

  /// We need the blueprint piles
  BlueprintProvider blueprints;

  /// We need active panels
  late BatteryWarehouse warehouse;

  /// We need active puzzles
  AssemblyBay assemblyBay = AssemblyBay(bayCount: 4);

  /// We need staged Pieces
  late PieceStaging pieceStaging;

  /// We need the upcycled Pieces
  late UpcycleController upcycleController;

  /// We need the toolbox (player hand, avaialble pieces)
  /// We also need the currently generated number
  final TargetTiers targets;

  /// We need the target numbers

  final Player player = Player();

  BoardState(
      {required this.onWin,
      required this.onLoss,
      required this.blueprints,
      required this.targets}) {
    player.addListener(_handlePlayerChange);
    pieceStaging = PieceStaging(boardState: this);
    warehouse =
        BatteryWarehouse(boardState: this, bayCount: 6, targets: targets);
    actionManager =
        ActionManager(this, dayRounds: 3, nightRounds: 2, warehouse: warehouse);
    upcycleController = UpcycleController(boardState: this);
  }

  // List<PlayingArea> get areas => [areaOne, areaTwo];

  void dispose() {
    player.removeListener(_handlePlayerChange);
    // areaOne.dispose();
    // areaTwo.dispose();
  }

  void _handlePlayerChange() {
    // if (player.hand.isEmpty) {
    //   onWin();
    // }
  }

  bool canAddPuzzle() {
    return assemblyBay.hasOpenBay() && !actionManager.currentRoundComplete();
  }

  void purchaseBlueprint(Blueprint blueprint) {
    if (actionManager
        .currentRoundCanAcceptActionType(ActionType.boughtBlueprint)) {
      Panel? resultingPanel = assemblyBay.addPuzzle(blueprint);

      if (resultingPanel != null) {
        blueprints.removeBlueprint(blueprint);

        actionManager.handleAction(BoughtBlueprintAction(
            originalBlueprint: blueprint, resultingPanel: resultingPanel));
      }
    }
  }

  void handleStagedPiece(StagedPiece stagedPiece) {
    pieceStaging.handleStagedPiece(stagedPiece);
  }

  void recycleSolarPanel(Battery battery) {
    if (warehouse.removeBattery(battery)) {
      for (PlacedPiece piece in battery.panel.placedPieces) {
        player.addPiece(piece.piece);
      }
      actionManager.handleAction(RecycledPanelAction(panel: battery.panel));
    }
  }

  void handleCompletedPuzzle(Panel panel) {
    if (warehouse.addPanel(panel)) {
      assemblyBay.removePuzzle(panel);
    }
  }

  bool shouldBlockPieceForEfficientAction() {
    return pieceStaging.awaitingPlacePieceAction() &&
        actionManager.currentRoundHasUsedEfficientAction();
  }

  void handleShiftIncremented() {
    blueprints.nextRound();
  }

  void triggerWin() {
    onWin();
  }

  void triggerFailure() {
    onLoss();
  }
}
