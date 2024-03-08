// Copyright 2024, Andrew Thatcher

import 'package:card/game_internals/card/board_state.dart';
import 'package:card/play_session/assembly/assembly_bay_controlls_widget.dart';
import 'package:card/play_session/assembly/assembly_bay_widget.dart';
import 'package:card/play_session/card/hand_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          child: AssemblyBayWidget(assemblyBay: boardState.assemblyBay),
        ),
        HandAnimationWidget(
          player: boardState.player,
          upcycleController: boardState.upcycleController,
        ),
      ],
    );
  }
}
