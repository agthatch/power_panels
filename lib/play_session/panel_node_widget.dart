import 'package:card/game_internals/panel/panel.dart';
import 'package:card/game_internals/panel/panel_node.dart';
import 'package:card/play_session/playing_piece_widget.dart';
import 'package:card/style/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PanelNodeWidget extends StatefulWidget {
  final Panel panel;
  final int x;
  final int y;

  const PanelNodeWidget(
      {super.key, required this.panel, required this.x, required this.y});

  @override
  State<StatefulWidget> createState() => _PanelNodeWidgetState();
}

class _PanelNodeWidgetState extends State<PanelNodeWidget> {
  @override
  Widget build(BuildContext context) {
    PanelNode node = widget.panel.nodes[widget.x][widget.y];
    final palette = context.watch<Palette>();

    return DragTarget<PlayingPieceDragData>(
      builder: (context, candidateData, rejectedData) => SizedBox(
        height: PlayingPieceWidget.width,
        width: PlayingPieceWidget.width,
        child: Material(
            clipBehavior: Clip.hardEdge,
            child: Container(
                decoration: BoxDecoration(
              color: determineColor(node, palette),
              border: Border.all(color: Color.fromRGBO(0, 0, 0, 0.288)),
            ))),
      ),
      onWillAcceptWithDetails: _onDragWillAccept,
      onLeave: _onDragLeave,
      onAcceptWithDetails: _onDragAccept,
    );
  }

  Color determineColor(PanelNode node, Palette palette) {
    if (node.occupied) {
      return palette.backgroundLevelSelection;
    } else if (!node.highlighted) {
      return palette.trueWhite;
    } else if (node.obstructed) {
      return palette.redPen;
    } else {
      return palette.accept;
    }
  }

  void _onAreaTap() {}

  void _onDragAccept(DragTargetDetails<PlayingPieceDragData> details) {
    details.data.holder?.removePiece(details.data.piece);
    widget.panel.handlePiecePlacement(details.data.piece, widget.x, widget.y);
  }

  void _onDragLeave(PlayingPieceDragData? data) {
    widget.panel.clearAllHighlights();
    var node = widget.panel.nodes[widget.x][widget.y];
    setState(() => node.highlighted = false);
  }

  bool _onDragWillAccept(DragTargetDetails<PlayingPieceDragData> details) {
    widget.panel.handlePieceHovering(details.data.piece, widget.x, widget.y);
    return widget.panel.canAcceptHoveringPiece ?? false;
  }
}
