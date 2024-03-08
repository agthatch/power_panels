import 'package:card/game_internals/piece/playing_piece.dart';
import 'package:card/game_internals/upcycling/upcycle_controller.dart';
import 'package:card/play_session/playing_piece_widget.dart';
import 'package:flutter/material.dart';

class UpcyclerWidget extends StatelessWidget {
  final UpcycleController controller;

  const UpcyclerWidget({super.key, required this.controller});

  Widget _buildInbox() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Inbox'),
      ),
    );
  }

  Widget _buildMiddleSection(List<PlayingPiece> items) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: items.map((item) => PlayingPieceWidget(item)).toList(),
        ),
      ),
    );
  }

  Widget _buildOutbox() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Outbox'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: controller.playerChanges,
      builder: (context, snapshot) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildInbox()),
            SizedBox(width: 8.0),
            Expanded(
                flex: 2,
                child: _buildMiddleSection(controller.potentialPieces)),
            SizedBox(width: 8.0),
            Expanded(child: _buildOutbox()),
          ],
        );
      },
    );
  }
}
