import 'dart:core';

import 'package:card/game_internals/panel/panel.dart';
import 'package:card/play_session/panel_node_widget.dart';
import 'package:card/play_session/playing_piece_widget.dart';
import 'package:flutter/material.dart';

class PanelWidget extends StatefulWidget {
  final Panel panel;

  const PanelWidget({super.key, required this.panel});

  @override
  State<StatefulWidget> createState() => _PlayingPieceWidgetState();
}

class _PlayingPieceWidgetState extends State<PanelWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0, // Adjust the elevation as needed
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Top Text',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          FrameWidget(panel: widget.panel),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Bottom Text',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}

class FrameWidget extends StatelessWidget {
  final Panel panel;
  const FrameWidget({super.key, required this.panel});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topLeft, children: [
      generateBackground(context),
    ]);
  }

  Container generateBackground(BuildContext context) {
    return Container(
      width: 200.0,
      height: 200.0,
      color: Colors.blue,
      child: Center(
        child: SizedBox(
            height: panel.dimY * PlayingPieceWidget.width,
            width: panel.dimX * PlayingPieceWidget.width,
            child: _createFrameGrid(panel, context)),
      ),
    );
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
