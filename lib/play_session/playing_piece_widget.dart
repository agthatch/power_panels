import 'package:card/audio/audio_controller.dart';
import 'package:card/audio/sounds.dart';
import 'package:card/game_internals/card/player.dart';
import 'package:card/game_internals/rotation.dart';
import '../game_internals/playing_piece.dart';
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
    double translateX = _determineNeededXTranslation(widget.piece);
    double translateY = _determineNeededYTranslation(widget.piece);
    final pieceWidget = Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: IntrinsicWidth(
        child: IntrinsicHeight(
          child: Transform(
            alignment: Alignment.center,
            // transform: Matrix4.identity()
            //   ..scale(widget.piece.mirrored ? -1.0 : 1.0, 1.0, 1.0)
            //   ..rotateZ(
            //       widget.piece.rotation.degrees() * (3.141592653589793 / 180)),
            transform: Matrix4.identity()
              ..rotateY(
                  widget.piece.mirrored ? 180 * (3.141592653589793 / 180) : 0)
              ..rotateZ(
                  widget.piece.rotation.degrees() * (3.141592653589793 / 180))
              ..translate(translateX, translateY),
            child: SizedBox(
                height: widget.piece.maxY * PlayingPieceWidget.width,
                width: widget.piece.maxX * PlayingPieceWidget.width,
                child: _createPieceWidget(widget.piece)),
          ),
        ),
      ),
    );

    if (widget.piece.isPlaced) {
      return pieceWidget;
    }

    return Draggable(
      feedback: Transform.rotate(
        angle: 0.1,
        child: pieceWidget,
      ),
      data: PlayingPieceDragData(widget.piece, widget.player),
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
      onSecondaryTap: _handleDoubleTap,
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: piece.maxX),
          itemCount: piece.maxX * piece.maxY,
          itemBuilder: (BuildContext context, int index) {
            int row = (index / piece.maxX).floor();
            int col = index % piece.maxX;

            bool isNode = piece.shape[row][col];
            return _createNodeWidget(row, col, isNode);
          }),
    );
  }

  Widget _createNodeWidget(int row, int col, bool isNode) {
    return GestureDetector(
      onLongPressDown: (details) {
        print('Draggable longPress down at ($row, $col)');
        widget.piece.setHandledNodeCoordinate(row, col);
      },
      child: !isNode
          ? Container(
              color: Color.fromRGBO(0, 0, 0, 0),
            )
          : SizedBox(
              height: PlayingPieceWidget.width,
              width: PlayingPieceWidget.width,
              child: Container(
                  decoration: BoxDecoration(
                color: Color.fromRGBO(51, 255, 0, 1),
                border: Border.all(color: Color.fromRGBO(0, 0, 0, 1)),
                borderRadius: BorderRadius.circular(3),
              )),
            ),
    );
  }

  void _handleTap() {
    if (widget.piece.isPlaced) return;
    print('item was tapped we should be rotating');

    setState(() {
      widget.piece.rotatePositive90();
    });
  }

  void _handleDoubleTap() {
    if (widget.piece.isPlaced) return;
    print('item was double tapped we should be mirroring');

    setState(() {
      widget.piece.mirror();
    });
  }

  double _determineNeededXTranslation(PlayingPiece piece) {
    if (piece.isSquare()) {
      return 0.0;
    }

    double offset = (piece.maxY - piece.maxX) * PlayingPieceWidget.width / 2;
    if (piece.mirrored) {
      switch (piece.rotation) {
        case Rotation.R0:
        case Rotation.R180:
          return 0.0;
        case Rotation.R90:
          return -offset;
        case Rotation.R270:
          return offset;
      }
    } else {
      switch (piece.rotation) {
        case Rotation.R0:
        case Rotation.R180:
          return 0.0;
        case Rotation.R90:
          return -offset;
        case Rotation.R270:
          return offset;
      }
    }
  }

  double _determineNeededYTranslation(PlayingPiece piece) {
    if (piece.isSquare()) {
      return 0.0;
    }

    double offset = (piece.maxY - piece.maxX) * PlayingPieceWidget.width / 2;
    if (piece.mirrored) {
      switch (piece.rotation) {
        case Rotation.R0:
        case Rotation.R180:
          return 0.0;
        case Rotation.R90:
          return offset;
        case Rotation.R270:
          return -offset;
      }
    } else {
      switch (piece.rotation) {
        case Rotation.R0:
        case Rotation.R180:
          return 0.0;
        case Rotation.R90:
          return -offset;
        case Rotation.R270:
          return offset;
      }
    }
  }
}

@immutable
class PlayingPieceDragData {
  final PlayingPiece piece;

  final Player? holder;

  const PlayingPieceDragData(this.piece, this.holder);
}
