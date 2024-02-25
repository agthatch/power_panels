import 'package:card/game_internals/card/player.dart';
import 'package:card/play_session/playing_piece_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../game_internals/card/board_state.dart';

class PlayerHandWidget extends StatelessWidget {
  final Player player;
  const PlayerHandWidget({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    final boardState = context.watch<BoardState>();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListenableBuilder(
          listenable: player,
          builder: (context, child) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: PlayingPieceWidget.width * 4,
                maxHeight: player.handIsExpanded
                    ? double.infinity
                    : PlayingPieceWidget.width * 4,
              ),
              child: Row(
                children: [
                  IconButton(
                      onPressed: boardState.player.toggleHandExpand,
                      icon: boardState.player.handIsExpanded
                          ? Icon(Icons.arrow_downward)
                          : Icon(Icons.arrow_upward)),
                  Expanded(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 20,
                      runSpacing: 10,
                      children: [
                        ...boardState.player.hand.map((piece) => SizedBox(
                            width: PlayingPieceWidget.width * 4,
                            height: PlayingPieceWidget.width * 4,
                            child: Center(
                                child: PlayingPieceWidget(piece,
                                    player: boardState.player)))),
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: boardState.player.toggleHandExpand,
                      icon: boardState.player.handIsExpanded
                          ? Icon(Icons.arrow_downward)
                          : Icon(Icons.arrow_upward))
                ],
              ),
            );
          }),
    );
  }
}
