import 'package:card/game_internals/blueprint/blueprint.dart';
import 'package:card/game_internals/card/board_state.dart';
import 'package:card/game_internals/panel/panel.dart';
import 'package:card/play_session/panel_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlueprintWidget extends StatefulWidget {
  final Blueprint blueprint;

  const BlueprintWidget({super.key, required this.blueprint});

  @override
  State<BlueprintWidget> createState() => _BlueprintWidgetState();
}

class _BlueprintWidgetState extends State<BlueprintWidget> {
  @override
  Widget build(BuildContext context) {
    final boardState = context.watch<BoardState>();

    return Card(
      elevation: 10.0,
      color: Color.fromARGB(255, 54, 73, 244).withOpacity(1),
      child: DecoratedBox(
        decoration: BoxDecoration(
            gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.75,
          colors: const [
            Color.fromRGBO(59, 147, 183, 1),
            Color.fromRGBO(27, 102, 159, 1)
          ],
        )),
        child: GridPaper(
          divisions: 3,
          interval: 200.0,
          child: SizedBox(
            width: 202,
            height: 202,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _createTopSection(boardState),
                Expanded(
                  child:
                      FrameWidget(panel: Panel.fromBlueprint(widget.blueprint)),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    'Capacity: ${widget.blueprint.storageCapacity} GWh',
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createTopSection(BoardState boardState) {
    return Row(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
        child: Text(
          'Blueprint',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
      Expanded(
        child: Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: boardState.canAddPuzzle()
                ? () {
                    boardState.purchaseBlueprint(widget.blueprint);
                  }
                : null,
            child: Text('Select',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                  // fontSize: 18,
                )), // Button text
          ),
        ),
      ),
    ]);
  }
}
