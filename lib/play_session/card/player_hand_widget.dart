import 'package:card/game_internals/card/player.dart';
import 'package:card/game_internals/upcycling/upcycle_controller.dart';
import 'package:card/play_session/playing_piece_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../game_internals/card/board_state.dart';

class PlayerHandWidget extends StatefulWidget {
  final Player player;
  final UpcycleController upcycleController;
  const PlayerHandWidget(
      {super.key, required this.player, required this.upcycleController});

  @override
  State<PlayerHandWidget> createState() => _PlayerHandWidgetState();
}

class _PlayerHandWidgetState extends State<PlayerHandWidget> {
  @override
  Widget build(BuildContext context) {
    final boardState = context.watch<BoardState>();

    return ListenableBuilder(
        listenable: widget.player,
        builder: (context, child) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: PlayingPieceWidget.width * 4,
              maxHeight: widget.player.handIsExpanded
                  ? (PlayingPieceWidget.width * 5) * 3
                  : PlayingPieceWidget.width * 5,
            ),
            child: Row(
              children: [
                makeToggleButtons(boardState),
                Expanded(
                  child: getHandWithProperExpansion(boardState),
                ),
                makeToggleButtons(boardState)
              ],
            ),
          );
        });
  }

  Widget makeToggleButtons(BoardState boardState) {
    return SizedBox(
      height: 120.0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            IconButton(
                onPressed: _toggleExpanded,
                icon: boardState.player.handIsExpanded
                    ? Icon(Icons.arrow_downward)
                    : Icon(Icons.arrow_upward)),
            if (boardState.player.handIsExpanded)
              IconButton(
                  onPressed: _toggleUpcycling,
                  icon: boardState.upcycleController.show
                      ? Icon(Icons.cancel)
                      : Icon(Icons.move_up)),
          ],
        ),
      ),
    );
  }

  void _toggleExpanded() {
    widget.player.toggleHandExpand();
    widget.upcycleController.setVisibility(false);
  }

  void _toggleUpcycling() {
    widget.upcycleController.toggleView();
    widget.player.externalNotifyListnerCall();
  }

  Widget getHandWithProperExpansion(BoardState boardState) {
    Wrap child = Wrap(
      alignment: WrapAlignment.center,
      spacing: 0,
      runSpacing: 0,
      children: [
        ...boardState.player.hand.map((piece) => Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                  width: PlayingPieceWidget.width * 4,
                  height: PlayingPieceWidget.width * 4,
                  child: Center(
                      child: PlayingPieceWidget(piece,
                          player: boardState.player))),
            )),
      ],
    );

    if (boardState.player.handIsExpanded) {
      return SingleChildScrollView(
        physics: boardState.player.handIsExpanded
            ? AlwaysScrollableScrollPhysics()
            : NeverScrollableScrollPhysics(),
        child: child,
      );
    } else {
      return child;
    }
  }
}
