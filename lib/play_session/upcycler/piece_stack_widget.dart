import 'dart:math';

import 'package:card/game_internals/piece/playing_piece.dart';
import 'package:card/game_internals/upcycling/piece_stack.dart';
import 'package:card/play_session/playing_piece_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../style/palette.dart';

class PieceStackWidget extends StatefulWidget {
  final PieceStack stack;

  const PieceStackWidget({required this.stack, super.key});

  @override
  State<PieceStackWidget> createState() => _PieceStackWidgetState();
}

class _PieceStackWidgetState extends State<PieceStackWidget> {
  bool isHighlighted = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return LimitedBox(
      maxHeight: 150,
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: SizedBox(
          height: 100,
          child: InkWell(
            splashColor: palette.redPen,
            onTap: _onAreaTap,
            child: _StackOfPieces._pieceStack(widget.stack.pieces),
          ),
        ),
      ),
    );
  }

  void _onAreaTap() {
    widget.stack.removeLastPiece();
  }
}

class _StackOfPieces extends StatelessWidget {
  static const int _maxPieces = 16;

  static const _leftOffset = 10.0;

  static const _topOffset = 10.0;

  static const double _maxWidth = 120.0;
  // _maxPieces * _leftOffset + PlayingPieceWidget.width * 2;

  static const double _maxHeight = 120.0;
  //  _maxPieces * _topOffset + PlayingCardWidget.height;

  final List<PlayingPiece> pieces;

  const _StackOfPieces._pieceStack(this.pieces);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: _maxWidth,
        height: _maxHeight,
        child: Stack(
          children: [
            for (var i = max(0, pieces.length - _maxPieces);
                i < pieces.length;
                i++)
              Positioned(
                top: (i + 1) * _topOffset,
                left: (i + 1) * _leftOffset,
                child: PlayingPieceWidget(pieces[i]),
              ),
          ],
        ),
      ),
    );
  }
}
