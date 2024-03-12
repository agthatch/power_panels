import 'package:card/audio/audio_controller.dart';
import 'package:card/audio/sounds.dart';
import 'package:card/game_internals/card/board_state.dart';
import 'package:card/game_internals/card/player.dart';
import 'package:card/game_internals/rotation.dart';
import 'package:card/play_session/piece_color_getter.dart';
import '../game_internals/piece/playing_piece.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayingPieceWidget extends StatefulWidget {
  static const double width = 20;

  final PlayingPiece piece;
  final Player? player;

  const PlayingPieceWidget(this.piece, {this.player, super.key});

  @override
  State<PlayingPieceWidget> createState() => _PlayingPieceWidgetState();
}

class _PlayingPieceWidgetState extends State<PlayingPieceWidget> {
  @override
  Widget build(BuildContext context) {
    // final palette = context.watch<Palette>();
    final pieceWidget = StreamBuilder(
        stream: widget.piece.playerChanges,
        builder: (context, child) {
          return SizedBox(
              height: determineSizedBoxHeight(widget.piece),
              width: determineSizedBoxWidth(widget.piece),
              child: _createPieceWidget(widget.piece));
        });

    if (widget.piece.isStaged) {
      return pieceWidget;
    }

    try {
      final BoardState boardState = context.watch<BoardState>();

      return Draggable(
        feedback: Transform.rotate(
          angle: 0.1,
          child: pieceWidget,
        ),
        data: PlayingPieceDragData(widget.piece, widget.player, boardState),
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
    } catch (e) {
      return pieceWidget;
    }
  }

  double determineSizedBoxHeight(PlayingPiece piece) {
    switch (piece.rotation) {
      case Rotation.R0:
      case Rotation.R180:
        return piece.maxY * PlayingPieceWidget.width;
      case Rotation.R90:
      case Rotation.R270:
        return piece.maxX * PlayingPieceWidget.width;
    }
  }

  double determineSizedBoxWidth(PlayingPiece piece) {
    switch (piece.rotation) {
      case Rotation.R0:
      case Rotation.R180:
        return piece.maxX * PlayingPieceWidget.width;
      case Rotation.R90:
      case Rotation.R270:
        return piece.maxY * PlayingPieceWidget.width;
    }
  }

  Widget _createPieceWidget(PlayingPiece piece) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: piece.currentMaxX()),
        itemCount: piece.maxX * piece.maxY,
        itemBuilder: (BuildContext context, int index) {
          int maxX = piece.currentMaxX();
          int row = (index / maxX).floor();
          int col = index % maxX;

          bool isNode = piece.currentShape[row][col];
          return _createNodeWidget(row, col, isNode);
        });
  }

  Widget _createNodeWidget(int row, int col, bool isNode) {
    Widget squareWidget = !isNode
        ? Container(
            height: PlayingPieceWidget.width,
            width: PlayingPieceWidget.width,
            color: Color.fromRGBO(0, 0, 0, 0),
          )
        : SizedBox(
            height: PlayingPieceWidget.width,
            width: PlayingPieceWidget.width,
            child: Container(
                decoration: BoxDecoration(
              color: PieceColorGetter.get(widget.piece.shape, context),
              border: Border.all(color: Color.fromRGBO(0, 0, 0, 1)),
              borderRadius: BorderRadius.circular(3),
            )),
          );

    if (widget.piece.isStaged) {
      return squareWidget;
    }

    return GestureDetector(
      onTap: _handleTap,
      onDoubleTap: _handleDoubleTap,
      onSecondaryTap: _handleDoubleTap,
      onLongPressDown: (details) {
        widget.piece.setHandledNodeCoordinate(row, col);
      },
      child: squareWidget,
    );
  }

  void _handleTap() {
    if (widget.piece.isStaged) return;

    setState(() {
      widget.piece.rotatePositive90();
    });
  }

  void _handleDoubleTap() {
    if (widget.piece.isStaged) return;
    setState(() {
      widget.piece.mirror();
    });
  }
}

@immutable
class PlayingPieceDragData {
  final PlayingPiece piece;
  final BoardState boardState;

  final Player? holder;

  const PlayingPieceDragData(this.piece, this.holder, this.boardState);
}
