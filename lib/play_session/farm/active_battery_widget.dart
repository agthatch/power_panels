import 'package:card/game_internals/card/board_state.dart';
import 'package:card/game_internals/grid/battery.dart';
import 'package:card/play_session/farm/charge_indicator_widget.dart';
import 'package:card/play_session/panel_widget.dart';
import 'package:card/style/wiggle_button.dart';
import 'package:flutter/material.dart';

class ActiveBatteryWidget extends StatelessWidget {
  final Battery battery;
  final BoardState boardState;

  const ActiveBatteryWidget({
    super.key,
    required this.battery,
    required this.boardState,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 229, 134, 68),
      child: SizedBox(
        height: 200,
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Charge: ${battery.charge.toStringAsFixed(1)} / ${battery.panel.storageCapacity}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  SizedBox(width: 20),
                  ChargeIndicatorWidget(battery: battery),
                  Spacer(),
                  FrameWidget(panel: battery.panel),
                  Spacer(),
                  ChargeIndicatorWidget(battery: battery),
                  SizedBox(width: 20),
                ],
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
    boardState.recycleSolarPanel(battery);
  }

  Widget _buildChargeIndicator(Battery battery) {
    return Container(
      color: Colors.amberAccent,
      child: SizedBox(
        height: 100,
        width: 10,
        child: RotatedBox(
          quarterTurns: -1, // Rotate the progress bar vertically
          child: LinearProgressIndicator(
            value: battery.chargePercent, // Set the progress value (0.0 to 1.0)
            backgroundColor: Colors.grey[300],
            color: Colors.blue,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          ),
        ),
      ),
    );
  }
}
