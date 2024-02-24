import 'package:card/game_internals/card/board_state.dart';
import 'package:card/game_internals/panel/panel.dart';
import 'package:card/play_session/panel_widget.dart';
import 'package:card/style/wiggle_button.dart';
import 'package:flutter/material.dart';

class SolarPanelWidget extends StatelessWidget {
  final Panel panel;
  final BoardState boardState;

  const SolarPanelWidget({
    super.key,
    required this.panel,
    required this.boardState,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 300,
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Daily Production: ${panel.generationValue}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.grey[200],
                child: Center(
                  child: FrameWidget(panel: panel),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  WiggleButton(
                    onPressed: _onRecycledPressed,
                    child: Text('Recycle'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onRecycledPressed() {
    boardState.recycleSolarPanel(panel);
  }
}
