// Copyright 2023, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:card/game_internals/blueprint/blueprint.dart';
import 'package:card/game_internals/card/board_state.dart';
import 'package:card/play_session/blueprint/blueprint_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'card/player_hand_widget.dart';

/// This widget defines the game UI itself, without things like the settings
/// button or the back button.
class BoardWidget extends StatefulWidget {
  const BoardWidget({super.key});

  @override
  State<BoardWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  @override
  Widget build(BuildContext context) {
    final boardState = context.watch<BoardState>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 20,
            children: _blueprintWidgets(
                boardState.easyBlueprints.getNextBlueprints(4)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: StreamBuilder(
              stream: boardState.assemblyBay.playerChanges,
              builder: (context, child) {
                return Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  runSpacing: 20,
                  children: [...boardState.assemblyBay.getWidgets()],
                );
              }),
        ),
        PlayerHandWidget(),
      ],
    );
  }

  List<Widget> _blueprintWidgets(List<Blueprint> nextBlueprints) {
    return nextBlueprints.map((e) => BlueprintWidget(blueprint: e)).toList();
  }
}
