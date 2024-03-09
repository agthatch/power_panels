import 'dart:core';

import 'package:card/game_internals/panel/panel.dart';
import 'package:card/play_session/panel_node_widget.dart';
import 'package:card/play_session/playing_piece_widget.dart';
import 'package:card/playground/pulsing_piece.dart';
import 'package:flutter/material.dart';

class PanelWidget extends StatefulWidget {
  final Panel panel;

  const PanelWidget({super.key, required this.panel});

  @override
  State<StatefulWidget> createState() => _PanelWidgetState();
}

class _PanelWidgetState extends State<PanelWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0, // Adjust the elevation as needed
      child: SizedBox(
        width: 200,
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _createTopSection(widget.panel),
            Expanded(child: FrameWidget(panel: widget.panel)),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(5.0),
              child: Text(
                'Capacity: ${widget.panel.storageCapacity} GWh',
                style: TextStyle(fontSize: 15.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createTopSection(Panel panel) {
    return Row(children: const [
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
          child: Text(
            'Assembling',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ]);
  }
}

class FrameWidget extends StatelessWidget {
  final Panel panel;
  const FrameWidget({super.key, required this.panel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.0,
      // height: 200.0,
      child: Center(
        child: StreamBuilder(
            stream: panel.allChanges,
            builder: (context, child) {
              return Stack(alignment: Alignment.topLeft, children: [
                generateBackground(context),
                ..._generatePlacedPieceWidgets(panel, context),
              ]);
            }),
      ),
    );
  }

  Widget generateBackground(BuildContext context) {
    return SizedBox(
        height: panel.dimY * PlayingPieceWidget.width,
        width: panel.dimX * PlayingPieceWidget.width,
        child: _createFrameGrid(panel, context));
  }

  List<Widget> _generatePlacedPieceWidgets(Panel panel, BuildContext context) {
    return panel.placedAndStagedPieces().map((placedPiece) {
      return Positioned(
        top: placedPiece.location.y * PlayingPieceWidget.width,
        left: placedPiece.location.x * PlayingPieceWidget.width,
        child:
            IgnorePointer(child: PulsingPieceWidget(piece: placedPiece.piece)),
      );
    }).toList();
  }
}

Widget _createFrameGrid(Panel panel, BuildContext context) {
  return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: panel.dimX),
      itemCount: panel.dimX * panel.dimY,
      itemBuilder: (BuildContext context, int index) {
        int y = (index / panel.dimX).floor();
        int x = index % panel.dimX;

        return _createNodeWidget(x, y, panel);
      });
}

Widget _createNodeWidget(int x, int y, Panel panel) {
  return PanelNodeWidget(panel: panel, x: x, y: y);
}
