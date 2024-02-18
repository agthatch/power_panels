// Copyright 2024, Andrew Thatcher

import 'package:card/game_internals/card/board_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'card/player_hand_widget.dart';

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
}
