// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:card/game_internals/blueprint/blueprint.dart';
import 'package:card/game_internals/blueprint/blueprint_builder.dart';
import 'package:card/game_internals/blueprint/blueprint_provider.dart';
import 'package:card/game_internals/blueprint/prefab_blueprint_provider.dart';
import 'package:card/game_internals/card/board_state.dart';
import 'package:card/game_internals/grid/target_tiers.dart';
import 'package:card/game_internals/piece/piece_data.dart';
import 'package:card/game_internals/piece/placed_piece_builder.dart';
import 'package:card/game_internals/rotation.dart';
import 'package:card/game_internals/rounds/action_manager.dart';
import 'package:card/game_internals/warehouse/battery_warehouse.dart';
import 'package:card/play_session/assembly/empty_station_widget.dart';
import 'package:card/play_session/blueprint/blueprint_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:provider/provider.dart';

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
            title: RoundInfoWidget(
              actionManager: _boardState.actionManager,
              warehouse: _boardState.warehouse,
            ),
            leading: LeadingButton(),
            actions: const [
              TrailingWidget(),
            ],
          ),
          backgroundColor: palette.backgroundPlaySession,
          drawer: Drawer(
            backgroundColor: Colors.blueAccent.shade400,
            child: StreamBuilder(
                stream: _boardState.blueprints.getChangeStream(),
                builder: (context, child) {
                  return createDrawerInternals(
                      header: createBlueprintHeader(_boardState),
                      headerColor: Colors.blueAccent,
                      content: _blueprintWidgets(
                          _boardState.blueprints.getBlueprintsForRound(),
                          _boardState));
                }),
          ),
          endDrawer: Drawer(
              child: StreamBuilder(
                  stream: _boardState.warehouse.playerChanges,
                  builder: (context, child) {
                    return createDrawerInternals(
                        header: createSolarFarmHeader(_boardState),
                        headerColor: Color.fromARGB(255, 220, 175, 0),
                        content: _boardState.warehouse.getWidgets());
                  })),
          body: Stack(
            children: [
              Positioned.fill(child: BoardWidget()),
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
      onLoss: _playerLost,
      blueprints: _easyBlueprints(),
      targets: _game1TargetTiers(),
    );
  }

  Future<void> _playerWon() async {
    _log.info('Player won');

    // TODO: replace with some meaningful score for the card game
    final score = Score(_boardState.actionManager.dayNumber + 1,
        _boardState.warehouse.dailyCapacity(), _boardState.blueprints.getAll());
    // Let the player see the game just after winning for a bit.
    await Future<void>.delayed(_preCelebrationDuration);
    if (!mounted) return;

    setState(() {
      _duringCelebration = true;
    });

    /// Give the player some time to see the celebration animation.
    await Future<void>.delayed(_celebrationDuration);
    if (!mounted) return;

    GoRouter.of(context).go('/play/won', extra: {'score': score});
  }

  Future<void> _playerLost() async {
    _log.info('Player lost');

    final score = Score(_boardState.actionManager.dayNumber,
        _boardState.warehouse.dailyCapacity(), []);

    // final playerProgress = context.read<PlayerProgress>();
    // playerProgress.setLevelReached(widget.level.number);

    // Let the player see the game just after winning for a bit.
    await Future<void>.delayed(_preCelebrationDuration);
    if (!mounted) return;

    setState(() {
      _duringCelebration = true;
    });

    /// Give the player some time to see the celebration animation.
    await Future<void>.delayed(_celebrationDuration);
    if (!mounted) return;

    GoRouter.of(context).go('/play/won', extra: {'score': score});
  }
}

class RoundInfoWidget extends StatelessWidget {
  const RoundInfoWidget({
    super.key,
    required this.actionManager,
    required this.warehouse,
  });

  final ActionManager actionManager;
  final BatteryWarehouse warehouse;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: StreamBuilder(
            stream: actionManager.getChangeStream(),
            builder: (context, child) {
              return Center(
                child: Row(
                  children: [
                    Spacer(),
                    Text(actionManager.getShiftInfo()),
                    SizedBox(
                      width: 50,
                    ),
                    StreamBuilder(
                        stream: warehouse.playerChanges,
                        builder: (context, snapshot) {
                          return Text(warehouse
                              .getCurrentInfo(actionManager.dayNumber));
                        }),
                    Spacer(),
                  ],
                ),
              );
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

List<Widget> _blueprintWidgets(
    List<Blueprint?> nextBlueprints, BoardState boardState) {
  return nextBlueprints
      .map((e) => e != null
          ? BlueprintWidget(
              blueprint: e,
              boardState: boardState,
            )
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
          Text(boardState.blueprints.getCurrentRoundData(),
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
          Text('${boardState.blueprints.getRemainingCount()}',
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
  return StreamBuilder(
      stream: boardState.warehouse.playerChanges,
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First row: Solar Farm
            Text(
              'Battery Warehouse',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8), // Add some space between rows
            // Second row: Total Daily Production
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16.0), // Indentation
                  child: Text('Charge: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      )),
                ),
                Text(boardState.warehouse.getChargeOverCapacity(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ))
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16.0), // Indentation
                  child: Text('Required: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      )),
                ),
                Text(
                    '${boardState.warehouse.getCurrentRequirement(boardState.actionManager.dayNumber)} GWh',
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
                    '${boardState.warehouse.openBayCount}/${boardState.warehouse.bayCount}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    )),
              ],
            ),
          ],
        );
      });
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
        height: 150, // Height of the frozen header
        width: double.infinity,
        color: headerColor,
        child: Padding(padding: EdgeInsets.all(16), child: header),
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

  provider.addBlueprint(
      BlueprintBuilder().withXDim(3).withYDim(3).withStorageCapacity(2));

  provider.addBlueprint(BlueprintBuilder()
      .withXDim(5)
      .withYDim(5)
      .withStorageCapacity(5)
      .withPrefitPiece(PlacedPieceBuilder()
          .withShape(Shape.lineTwo)
          .withRotation(Rotation.R90)
          .withMirrored(false)
          .withLocation(x: 2, y: 3)
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

  provider.addBlueprint(BlueprintBuilder()
      .withXDim(3)
      .withYDim(5)
      .withStorageCapacity(3)
      .withPrefitPiece(PlacedPieceBuilder()
          .withShape(Shape.single)
          .withRotation(Rotation.R0)
          .withMirrored(false)
          .withLocation(x: 2, y: 0)
          .build())
      .withPrefitPiece(PlacedPieceBuilder()
          .withShape(Shape.lineTwo)
          .withRotation(Rotation.R0)
          .withMirrored(false)
          .withLocation(x: 0, y: 2)
          .build()));

  provider.addBlueprint(BlueprintBuilder()
      .withXDim(4)
      .withYDim(4)
      .withStorageCapacity(2)
      .withPrefitPiece(PlacedPieceBuilder()
          .withShape(Shape.corner)
          .withRotation(Rotation.R90)
          .withMirrored(false)
          .withLocation(x: 0, y: 0)
          .build())
      .withPrefitPiece(PlacedPieceBuilder()
          .withShape(Shape.square)
          .withRotation(Rotation.R0)
          .withMirrored(false)
          .withLocation(x: 0, y: 2)
          .build()));

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

  provider.addBlueprint(
      BlueprintBuilder().withXDim(3).withYDim(3).withStorageCapacity(2));

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

TargetTiers _game1TargetTiers() {
  TargetTiersBuilder builder = TargetTiersBuilder();
  builder.withTier(lowerBound: 0, target: 0);
  builder.withTier(lowerBound: 3, target: 2);
  builder.withTier(lowerBound: 7, target: 7);

  return builder.build();
}

TargetTiers _game2TargetTiers() {
  TargetTiersBuilder builder = TargetTiersBuilder();
  builder.withTier(lowerBound: 0, target: 0);
  builder.withTier(lowerBound: 3, target: 3);
  builder.withTier(lowerBound: 6, target: 9);
  builder.withTier(lowerBound: 9, target: 15);

  return builder.build();
}
