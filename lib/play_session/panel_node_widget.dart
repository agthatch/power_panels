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
          color: node.highlighted ? palette.accept : palette.trueWhite,
          clipBehavior: Clip.hardEdge,
          child: StreamBuilder(
              // Rebuild the card stack whenever the area changes
              // (either by a player action, or remotely).
              stream: widget.panel.allChanges,
              builder: (context, child) => Container()),
        ),
      ),
      onWillAcceptWithDetails: _onDragWillAccept,
      onLeave: _onDragLeave,
      onAcceptWithDetails: _onDragAccept,
    );
  }

  void _onAreaTap() {}

  void _onDragAccept(DragTargetDetails<PlayingPieceDragData> details) {
    details.data.holder?.removePiece(details.data.piece);
    // setState(() => widget.node.occupied = true);
  }

  void _onDragLeave(PlayingPieceDragData? data) {
    var node = widget.panel.nodes[widget.x][widget.y];
    setState(() => node.highlighted = false);
  }

  bool _onDragWillAccept(DragTargetDetails<PlayingPieceDragData> details) {
    var node = widget.panel.nodes[widget.x][widget.y];
    setState(() => node.highlighted = true);
    //AGT: need to sleep, we need to now go through the nodes and determine if the piece can fit and highlight accordingly
    return true;
  }
}
