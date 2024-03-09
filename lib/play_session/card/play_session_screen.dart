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
import 'package:card/play_session/assembly/empty_station_widget.dart';
import 'package:card/play_session/blueprint/blueprint_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:provider/provider.dart';

import '../../audio/audio_controller.dart';
import '../../audio/sounds.dart';
import '../../game_internals/card/score.dart';
import '../../style/confetti.dart';
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
          appBar: AppBar(
            title: RoundInfoWidget(roundManager: _boardState.roundManager),
            leading: LeadingButton(),
            actions: const [
              TrailingWidget(),
            ],
          ),
          backgroundColor: palette.backgroundPlaySession,
          drawer: Drawer(
            child: StreamBuilder(
                stream: _boardState.easyBlueprints.getChangeStream(),
                builder: (context, child) {
                  return createDrawerInternals(
                      header: createBlueprintHeader(_boardState),
                      headerColor: Colors.blue,
                      content: _blueprintWidgets(
                          _boardState.easyBlueprints.getBlueprintsForRound()));
                }),
          ),
          endDrawer: Drawer(
              child: StreamBuilder(
                  stream: _boardState.solarFarm.playerChanges,
                  builder: (context, child) {
                    return createDrawerInternals(
                        header: createSolarFarmHeader(_boardState),
                        headerColor: Colors.green.shade400,
                        content: _boardState.solarFarm.getWidgets());
                  })),
          body: Stack(
            children: [
              // This is the main layout of the play session screen,
              // with a settings button at top, the actual play area
              // in the middle, and a back button at the bottom.
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Expanded(child: BoardWidget()),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: WiggleButton(
                  //     onPressed: () => GoRouter.of(context).go('/'),
                  //     child: const Text('Back'),
                  //   ),
                  // ),
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
      onWin: _playerWon,
      easyBlueprints: _easyBlueprints(),
    );
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

class RoundInfoWidget extends StatelessWidget {
  const RoundInfoWidget({
    super.key,
    required RoundManager roundManager,
  }) : _roundManager = roundManager;

  final RoundManager _roundManager;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: StreamBuilder(
            stream: _roundManager.getChangeStream(),
            builder: (context, child) {
              return Text(_roundManager.getRoundInfo());
            }));
  }
}

class TrailingWidget extends StatelessWidget {
  const TrailingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.warehouse,
        color: Colors.green,
      ),
      onPressed: () {
        Scaffold.of(context).openEndDrawer();
      },
    );
  }
}

class LeadingButton extends StatelessWidget {
  const LeadingButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.document_scanner_outlined,
        color: Colors.blue,
      ),
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
    );
  }
}

List<Widget> _blueprintWidgets(List<Blueprint?> nextBlueprints) {
  return nextBlueprints
      .map((e) => e != null
          ? BlueprintWidget(blueprint: e)
          : EmptyStation(bayNumber: 0))
      .toList();
}

Row _paddedRow(Widget w) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [Spacer(), w, Spacer()],
  );
}

Widget createBlueprintHeader(BoardState boardState) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // First row: Solar Farm
      const Row(
        children: [
          Text(
            'Available Blueprints',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
      SizedBox(height: 8), // Add some space between rows
      // Second row: Total Daily Production
      Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16.0), // Indentation
            child: Text('Available This Round: ',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                )),
          ),
          Text(boardState.easyBlueprints.getCurrentRoundData(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ))
        ],
      ),

      // Third row: Open bays
      Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16.0), // Indentation
            child: Text('Total Remaining: ',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                )),
          ),
          Text('${boardState.easyBlueprints.getRemainingCount()}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
        ],
      ),
    ],
  );
}

Widget createSolarFarmHeader(BoardState boardState) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // First row: Solar Farm
      const Row(
        children: [
          Text(
            'Solar Farm',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
      SizedBox(height: 8), // Add some space between rows
      // Second row: Total Daily Production
      Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16.0), // Indentation
            child: Text('Total Daily Production: ',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                )),
          ),
          Text('${boardState.solarFarm.dailyCapacity()}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ))
        ],
      ),

      // Third row: Open bays
      Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16.0), // Indentation
            child: Text('Open bays: ',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                )),
          ),
          Text(
              '${boardState.solarFarm.openBayCount}/${boardState.solarFarm.bayCount}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
        ],
      ),
    ],
  );
}

Widget createDrawerInternals(
    {required Widget header,
    required Color headerColor,
    required List<Widget> content}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      // Frozen header
      Container(
        height: 120, // Height of the frozen header
        width: double.infinity,
        color: headerColor,
        child: Expanded(
            child: Padding(padding: EdgeInsets.all(16), child: header)),
      ),
      // Scrollable list of items
      Expanded(
        child: ListView.builder(
          itemCount: content.length,
          itemBuilder: (context, index) {
            // Generate dynamic items based on data
            final item = content[index];
            return ListTile(
              title: _paddedRow(item),
              // Add any desired properties to the ListTile
            );
          },
        ),
      ),
    ],
  );
}

BlueprintProvider _easyBlueprints() {
  PrefabBlueprintProvider provider =
      PrefabBlueprintProvider(blueprintsPerRound: 4);

  provider.addBlueprint(BlueprintBuilder()
      .withXDim(4)
      .withYDim(5)
      .withStorageCapacity(3)
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
      .withStorageCapacity(1)
      .withPrefitPiece(PlacedPieceBuilder()
          .withShape(Shape.corner)
          .withRotation(Rotation.R0)
          .withMirrored(false)
          .withLocation(x: 1, y: 1)
          .build()));

  provider.addBlueprint(BlueprintBuilder()
      .withXDim(3)
      .withYDim(3)
      .withStorageCapacity(1)
      .withPrefitPiece(PlacedPieceBuilder()
          .withShape(Shape.lineTwo)
          .withRotation(Rotation.R0)
          .withMirrored(false)
          .withLocation(x: 1, y: 1)
          .build()));

  provider.addBlueprint(BlueprintBuilder()
      .withXDim(3)
      .withYDim(3)
      .withStorageCapacity(1)
      .withPrefitPiece(PlacedPieceBuilder()
          .withShape(Shape.single)
          .withRotation(Rotation.R0)
          .withMirrored(false)
          .withLocation(x: 2, y: 2)
          .build()));

  provider.addBlueprint(BlueprintBuilder()
      .withXDim(3)
      .withYDim(3)
      .withStorageCapacity(1)
      .withPrefitPiece(PlacedPieceBuilder()
          .withShape(Shape.square)
          .withRotation(Rotation.R0)
          .withMirrored(false)
          .withLocation(x: 1, y: 1)
          .build()));

  provider.nextRound();

  return provider;
}
