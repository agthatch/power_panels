import 'package:card/game_internals/rounds/actions/piece_staging.dart';
import 'package:card/style/my_button.dart';
import 'package:flutter/material.dart';

class AssemblyBayControlsWidget extends StatelessWidget {
  final PieceStaging pieceStaging;

  const AssemblyBayControlsWidget({
    super.key,
    required this.pieceStaging,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _getButtons(pieceStaging));
  }

  List<Widget> _getButtons(PieceStaging pieceStaging) {
    List<Widget> buttons = [];

    if (pieceStaging.placePieceActionIsAvailable()) {
      buttons.add(WiggleButton(
          onPressed: pieceStaging.processPlacePieceAction,
          child: Text('Place Piece')));
    }

    if (pieceStaging.efficientActionIsAvailable()) {
      buttons.add(WiggleButton(
          onPressed: pieceStaging.processEfficientAction,
          child:
              Text('Efficient Action (${pieceStaging.countOfStagedPieces})')));
    }

    if (pieceStaging.unstageActionIsAvailable()) {
      buttons.add(WiggleButton(
          onPressed: pieceStaging.unstagePieces, child: Text('Return Pieces')));
    }

    return buttons;
  }
}
