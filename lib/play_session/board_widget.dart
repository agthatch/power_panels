// Copyright 2024, Andrew Thatcher

import 'package:card/game_internals/card/board_state.dart';
import 'package:card/play_session/assembly/assembly_bay_controlls_widget.dart';
import 'package:card/play_session/assembly/assembly_bay_widget.dart';
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
        StreamBuilder(
            stream: boardState.pieceStaging.playerChanges,
            builder: (context, child) {
              return AssemblyBayControlsWidget(
                  pieceStaging: boardState.pieceStaging);
            }),
        Expanded(
            child: Container(
          color: Color.fromRGBO(95, 151, 255, 1),
          child: AssemblyBayWidget(assemblyBay: boardState.assemblyBay),
        )),
        Container(
            color: Color.fromRGBO(125, 125, 125, .75),
            child: PlayerHandWidget()),
      ],
    );
  }
}
