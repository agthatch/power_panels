import 'package:card/game_internals/piece/playing_piece.dart';
import 'package:card/game_internals/upcycling/upcycle_controller.dart';
import 'package:card/play_session/playing_piece_widget.dart';
import 'package:card/play_session/upcycler/piece_stack_widget.dart';
import 'package:card/play_session/upcycler/upcycle_inbox.dart';
import 'package:card/style/wiggle_button.dart';
import 'package:flutter/material.dart';

class UpcyclerWidget extends StatelessWidget {
  final UpcycleController controller;

  const UpcyclerWidget({super.key, required this.controller});

  Widget _buildInbox() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(00.0),
        child: UpcycleInbox(
          upcycleController: controller,
        ),
      ),
    );
  }

  Widget _buildMiddleSection(List<PlayingPiece> items) {
    return Card(
      child: Card(
        color: Colors.white70,
        child: SizedBox(
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                  bottom: 0,
                  child: Text('Available Options',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ))),
              _centerWidget(items),
            ],
          ),
        ),
      ),
    );
  }

  Wrap _pieceOptions(List<PlayingPiece> items) {
    return Wrap(
      spacing: 0.0,
      runSpacing: 8.0,
      alignment: WrapAlignment.center,
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                    width: PlayingPieceWidget.width * 2,
                    height: PlayingPieceWidget.width * 4,
                    child: Center(
                        child: GestureDetector(
                            onTap: () {
                              controller.selectPiece(item);
                            },
                            child: PlayingPieceWidget(item)))),
              ))
          .toList(),
    );
  }

  Widget _buildOutbox() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Card(
            color: Colors.white70,
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: 120,
                    minHeight: 120,
                    maxWidth: 120,
                    minWidth: 60),
                child: Stack(alignment: Alignment.center, children: [
                  PieceStackWidget(stack: controller.resultingPieces),
                  Positioned(
                      bottom: 0,
                      child: Text('Output',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ))),
                ]))),
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
            SizedBox(width: 30.0),
            Expanded(flex: 1, child: _buildInbox()),
            SizedBox(width: 8.0),
            Expanded(
              flex: 3,
              child: _buildMiddleSection(controller.potentialPieces),
            ),
            SizedBox(width: 8.0),
            Expanded(
                flex: 1,
                child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 60, maxWidth: 120),
                    child: _buildOutbox())),
            SizedBox(width: 30.0),
          ],
        );
      },
    );
  }

  Widget _centerWidget(List<PlayingPiece> items) {
    if (items.isEmpty) {
      return WiggleButton(
          onPressed: controller.completeAction,
          child: Text('Complete Upcycle'));
    } else {
      return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          child: _pieceOptions(items));
    }
  }
}
