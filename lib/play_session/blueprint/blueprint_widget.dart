import 'package:card/game_internals/blueprint/blueprint.dart';
import 'package:card/game_internals/panel/panel.dart';
import 'package:card/play_session/panel_widget.dart';
import 'package:flutter/material.dart';

class BlueprintWidget extends StatefulWidget {
  final Blueprint blueprint;

  const BlueprintWidget({super.key, required this.blueprint});

  @override
  State<BlueprintWidget> createState() => _BlueprintWidgetState();
}

class _BlueprintWidgetState extends State<BlueprintWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      child: SizedBox(
        width: 200,
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top section with text
            Container(
              color: Colors.grey,
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Blueprint',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            // Middle section with blue container
            Expanded(
              child: Stack(
                children: [
                  FrameWidget(panel: Panel.fromBlueprint(widget.blueprint)),
                  Container(
                    color: Color.fromARGB(255, 54, 73, 244)
                        .withOpacity(0.5), // semi-transparent red
                  ),
                ],
              ),
            ),
            // Bottom section with text
            Container(
              color: Colors.grey,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(5.0),
              child: Text(
                'Efficiency: ${widget.blueprint.generationValue}',
                style: TextStyle(fontSize: 15.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
