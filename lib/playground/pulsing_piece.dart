import 'package:card/game_internals/piece/playing_piece.dart';
import 'package:card/play_session/piece_color_getter.dart';
import 'package:card/play_session/playing_piece_widget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PulsingPieceWidget extends StatefulWidget {
  final PlayingPiece piece;

  const PulsingPieceWidget({super.key, required this.piece});

  @override
  PulsingPieceWidgetState createState() => PulsingPieceWidgetState();
}

class PulsingPieceWidgetState extends State<PulsingPieceWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.piece.isStaged) {
      return Shimmer.fromColors(
        period: Duration(milliseconds: 2500),
        baseColor:
            PieceColorGetter.get(widget.piece.shape, context).withAlpha(200),
        highlightColor: Color.fromARGB(118, 77, 77, 77),
        child: Center(child: PlayingPieceWidget(widget.piece)),
      );
    } else {
      return PlayingPieceWidget(widget.piece);
    }
  }
}
