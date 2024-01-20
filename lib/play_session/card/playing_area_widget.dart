import 'dart:math';

import 'package:card/game_internals/playing_piece.dart';
import 'package:card/play_session/playing_piece_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../audio/audio_controller.dart';
import '../../audio/sounds.dart';
import '../../game_internals/card/playing_area.dart';
import '../../style/palette.dart';
import 'playing_card_widget.dart';

class PlayingAreaWidget extends StatefulWidget {
  final PlayingArea area;

  const PlayingAreaWidget(this.area, {super.key});

  @override
  State<PlayingAreaWidget> createState() => _PlayingAreaWidgetState();
}

class _PlayingAreaWidgetState extends State<PlayingAreaWidget> {
  bool isHighlighted = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return LimitedBox(
      maxHeight: 200,
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: DragTarget<PlayingPieceDragData>(
          builder: (context, candidateData, rejectedData) => SizedBox(
            height: 100,
            child: Material(
              color: isHighlighted ? palette.accept : palette.trueWhite,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: palette.redPen,
                onTap: _onAreaTap,
                child: StreamBuilder(
                  // Rebuild the card stack whenever the area changes
                  // (either by a player action, or remotely).
                  stream: widget.area.allChanges,
                  builder: (context, child) =>
                      _CardStack._PieceStack(widget.area.pieces),
                ),
              ),
            ),
          ),
          onWillAcceptWithDetails: _onDragWillAccept,
          onLeave: _onDragLeave,
          onAcceptWithDetails: _onDragAccept,
        ),
      ),
    );
  }

  void _onAreaTap() {
    widget.area.removeFirstCard();

    final audioController = context.read<AudioController>();
    audioController.playSfx(SfxType.huhsh);
  }

  void _onDragAccept(DragTargetDetails<PlayingPieceDragData> details) {
    widget.area.acceptPiece(details.data.piece);
    details.data.holder?.removePiece(details.data.piece);
    setState(() => isHighlighted = false);
  }

  void _onDragLeave(PlayingPieceDragData? data) {
    setState(() => isHighlighted = false);
  }

  bool _onDragWillAccept(DragTargetDetails<PlayingPieceDragData> details) {
    setState(() => isHighlighted = true);
    return true;
  }
}

class _CardStack extends StatelessWidget {
  static const int _maxCards = 6;

  static const _leftOffset = 10.0;

  static const _topOffset = 5.0;

  static const double _maxWidth =
      _maxCards * _leftOffset + PlayingCardWidget.width;

  static const _maxHeight = _maxCards * _topOffset + PlayingCardWidget.height;

  final List<PlayingPiece> pieces;

  const _CardStack._PieceStack(this.pieces);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: _maxWidth,
        height: _maxHeight,
        child: Stack(
          children: [
            for (var i = max(0, pieces.length - _maxCards);
                i < pieces.length;
                i++)
              Positioned(
                top: i * _topOffset,
                left: i * _leftOffset,
                child: PlayingPieceWidget(pieces[i]),
              ),
          ],
        ),
      ),
    );
  }
}
