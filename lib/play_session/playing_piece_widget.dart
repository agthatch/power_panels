import 'package:card/audio/audio_controller.dart';
import 'package:card/audio/sounds.dart';
import 'package:card/game_internals/card/player.dart';
import '../game_internals/playing_piece.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayingPieceWidget extends StatelessWidget {
  static const double width = 20;

  final PlayingPiece piece;
  final Player? player;

  const PlayingPieceWidget(this.piece, {this.player, super.key});

  @override
  Widget build(BuildContext context) {
    // final palette = context.watch<Palette>();

    final pieceWidget = Container(
        height: piece.maxY * width,
        width: piece.maxX * width,
        child: _createPieceWidget(piece));

    return Draggable(
      feedback: Transform.rotate(
        angle: 0.1,
        child: pieceWidget,
      ),
      data: PlayingPieceDragData(piece, Player()),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: pieceWidget,
      ),
      onDragStarted: () {
        final audioController = context.read<AudioController>();
        audioController.playSfx(SfxType.huhsh);
      },
      onDragEnd: (details) {
        final audioController = context.read<AudioController>();
        audioController.playSfx(SfxType.wssh);
      },
      child: pieceWidget,
    );
  }

  Widget _createPieceWidget(PlayingPiece piece) {
    return GestureDetector(
      onTap: _handleTap,
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: piece.maxX),
          itemCount: piece.maxX * piece.maxY,
          itemBuilder: (BuildContext context, int index) {
            int row = (index / piece.maxX).floor();
            int col = index % piece.maxX;

            if (piece.shape[row][col]) {
              return _createNodeWidget();
            }
            return Container();
          }),
    );
  }

  Widget _createNodeWidget() {
    return SizedBox(
      height: width,
      width: width,
      child: Container(
          decoration: BoxDecoration(
        color: Color.fromRGBO(51, 255, 0, 1),
        border: Border.all(color: Color.fromRGBO(0, 0, 0, 1)),
        borderRadius: BorderRadius.circular(3),
      )),
    );
  }

  void _handleTap() {
    piece.rotatePositive90();
  }
}

@immutable
class PlayingPieceDragData {
  final PlayingPiece piece;

  final Player holder;

  const PlayingPieceDragData(this.piece, this.holder);
}
