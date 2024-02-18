// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:card/game_internals/blueprint/blueprint.dart';
import 'package:card/game_internals/blueprint/blueprint_builder.dart';
import 'package:card/game_internals/blueprint/blueprint_provider.dart';
import 'package:card/game_internals/blueprint/prefab_blueprint_provider.dart';
import 'package:card/game_internals/card/board_state.dart';
import 'package:card/game_internals/piece/piece_data.dart';
import 'package:card/game_internals/piece/placed_piece_builder.dart';
import 'package:card/game_internals/rotation.dart';
import 'package:card/game_internals/rounds/round_manager.dart';
import 'package:card/play_session/blueprint/blueprint_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:provider/provider.dart';

import '../../audio/audio_controller.dart';
import '../../audio/sounds.dart';
import '../../game_internals/card/score.dart';
import '../../style/confetti.dart';
import '../../style/my_button.dart';
import '../../style/palette.dart';
import '../board_widget.dart';

/// This widget defines the entirety of the screen that the player sees when
/// they are playing a level.
///
/// It is a stateful widget because it manages some state of its own,
/// such as whether the game is in a "celebration" state.
class PlaySessionScreen extends StatefulWidget {
  const PlaySessionScreen({super.key});

  @override
  State<PlaySessionScreen> createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<PlaySessionScreen> {
  static final _log = Logger('PlaySessionScreen');

  static const _celebrationDuration = Duration(milliseconds: 2000);

  static const _preCelebrationDuration = Duration(milliseconds: 500);

  bool _duringCelebration = false;

  late DateTime _startOfPlay;

  late final BoardState _boardState;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return MultiProvider(
      providers: [
        Provider.value(value: _boardState),
      ],
      child: IgnorePointer(
        // Ignore all input during the celebration animation.
        ignoring: _duringCelebration,
        child: Scaffold(
          appBar: AppBar(),
          backgroundColor: palette.backgroundPlaySession,
          drawer: Drawer(
            child: ListView(
              children: [
                const DrawerHeader(child: Text("Available Blueprints")),
                ..._blueprintWidgets(
                    _boardState.easyBlueprints.getNextBlueprints(4))
              ],
            ),
          ),
          endDrawer: Drawer(),
          body: Stack(
            children: [
              // This is the main layout of the play session screen,
              // with a settings button at top, the actual play area
              // in the middle, and a back button at the bottom.
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkResponse(
                      onTap: () => GoRouter.of(context).push('/settings'),
                      child: Image.asset(
                        'assets/images/settings.png',
                        semanticLabel: 'Settings',
                      ),
                    ),
                  ),
                  const Spacer(),
                  // The actual UI of the game.
                  BoardWidget(),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyButton(
                      onPressed: () => GoRouter.of(context).go('/'),
                      child: const Text('Back'),
                    ),
                  ),
                ],
              ),
              SizedBox.expand(
                child: Visibility(
                  visible: _duringCelebration,
                  child: IgnorePointer(
                    child: Confetti(
                      isStopped: !_duringCelebration,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _boardState.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _startOfPlay = DateTime.now();
    _boardState = BoardState(
        roundManager: RoundManager(actionsPerRound: 4),
        onWin: _playerWon,
        easyBlueprints: _easyBlueprints(),
        hardBlueprints: _hardBlueprints());
  }

  Future<void> _playerWon() async {
    _log.info('Player won');

    // TODO: replace with some meaningful score for the card game
    final score = Score(1, 1, DateTime.now().difference(_startOfPlay));

    // final playerProgress = context.read<PlayerProgress>();
    // playerProgress.setLevelReached(widget.level.number);

    // Let the player see the game just after winning for a bit.
    await Future<void>.delayed(_preCelebrationDuration);
    if (!mounted) return;

    setState(() {
      _duringCelebration = true;
    });

    final audioController = context.read<AudioController>();
    audioController.playSfx(SfxType.congrats);

    /// Give the player some time to see the celebration animation.
    await Future<void>.delayed(_celebrationDuration);
    if (!mounted) return;

    GoRouter.of(context).go('/play/won', extra: {'score': score});
  }
}

List<Widget> _blueprintWidgets(List<Blueprint> nextBlueprints) {
  return nextBlueprints.map((e) => BlueprintWidget(blueprint: e)).toList();
}

BlueprintProvider _hardBlueprints() {
  PrefabBlueprintProvider provider = PrefabBlueprintProvider();

  provider.addBlueprint(BlueprintBuilder()
      .withXDim(4)
      .withYDim(5)
      .withPrefitPiece(PlacedPieceBuilder()
          .withShape(Shape.T)
          .withRotation(Rotation.R270)
          .withLocation(x: 1, y: 0)
          .build()));

  return provider;
}

BlueprintProvider _easyBlueprints() {
  PrefabBlueprintProvider provider = PrefabBlueprintProvider();

  provider.addBlueprint(BlueprintBuilder()
      .withXDim(4)
      .withYDim(5)
      .withGenerationValue(3)
      .withPrefitPiece(PlacedPieceBuilder()
          .withShape(Shape.L)
          .withRotation(Rotation.R90)
          .withMirrored(false)
          .withLocation(x: 0, y: 0)
          .build())
      .withPrefitPiece(PlacedPieceBuilder()
          .withShape(Shape.square)
          .withRotation(Rotation.R0)
          .withMirrored(false)
          .withLocation(x: 2, y: 3)
          .build()));

  provider.addBlueprint(BlueprintBuilder()
      .withXDim(3)
      .withYDim(3)
      .withGenerationValue(1)
      .withPrefitPiece(PlacedPieceBuilder()
          .withShape(Shape.corner)
          .withRotation(Rotation.R0)
          .withMirrored(false)
          .withLocation(x: 1, y: 1)
          .build()));

  provider.addBlueprint(BlueprintBuilder()
      .withXDim(3)
      .withYDim(3)
      .withGenerationValue(1)
      .withPrefitPiece(PlacedPieceBuilder()
          .withShape(Shape.lineTwo)
          .withRotation(Rotation.R0)
          .withMirrored(false)
          .withLocation(x: 1, y: 1)
          .build()));

  provider.addBlueprint(BlueprintBuilder()
      .withXDim(3)
      .withYDim(3)
      .withGenerationValue(1)
      .withPrefitPiece(PlacedPieceBuilder()
          .withShape(Shape.single)
          .withRotation(Rotation.R0)
          .withMirrored(false)
          .withLocation(x: 2, y: 2)
          .build()));

  provider.addBlueprint(BlueprintBuilder()
      .withXDim(3)
      .withYDim(3)
      .withGenerationValue(1)
      .withPrefitPiece(PlacedPieceBuilder()
          .withShape(Shape.square)
          .withRotation(Rotation.R0)
          .withMirrored(false)
          .withLocation(x: 1, y: 1)
          .build()));

  return provider;
}
