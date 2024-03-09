import 'package:card/game_internals/upcycling/upcycle_controller.dart';
import 'package:card/play_session/playing_piece_widget.dart';
import 'package:card/play_session/upcycler/piece_stack_widget.dart';
import 'package:flutter/material.dart';

class UpcycleInbox extends StatefulWidget {
  final UpcycleController upcycleController;
  const UpcycleInbox({super.key, required this.upcycleController});

  @override
  State<StatefulWidget> createState() => _UpcycleInboxState();
}

class _UpcycleInboxState extends State<UpcycleInbox> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return DragTarget<PlayingPieceDragData>(
      onAccept: (data) {
        setState(() {
          widget.upcycleController.piecesToUpcycle.add(data.piece);
          widget.upcycleController.boardState.player.removePiece(data.piece);
          isHovered = false;
        });

        // Handle the drop event
        // You can implement actions when a draggable item is dropped here
      },
      onWillAccept: (data) {
        setState(() {
          isHovered = true;
        });
        return true;
      },
      onLeave: (data) {
        // Handle the case when a draggable item leaves the drop target area
        setState(() {
          isHovered = false;
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Card(
          color: isHovered ? Colors.greenAccent : Colors.white70,
          child: SizedBox(
            width: 120,
            height: 120,
            child: Stack(alignment: Alignment.center, children: [
              PieceStackWidget(stack: widget.upcycleController.piecesToUpcycle),
              Positioned(
                  bottom: 0,
                  child: Text('Input',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ))),
            ]),
          ),
        );
      },
    );
  }
}
