import 'package:card/game_internals/rounds/actions/piece_staging.dart';
import 'package:card/style/wiggle_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AssemblyBayControlsWidget extends StatelessWidget {
  final PieceStaging pieceStaging;

  const AssemblyBayControlsWidget({
    super.key,
    required this.pieceStaging,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _getButtons(pieceStaging),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: InkResponse(
              onTap: () => GoRouter.of(context).push('/settings'),
              child: Icon(
                Icons.settings,
                size: 40.0,
                color: Colors.white60,
              ),
            ),
          ),
        )
      ],
    );
  }

  List<Widget> _getButtons(PieceStaging pieceStaging) {
    List<Widget> buttons = [];

    if (pieceStaging.awaitingPlacePieceAction()) {
      buttons.add(WiggleButton(
          onPressed: pieceStaging.processPlacePieceAction,
          child: Text('Place Piece')));
    }

    if (pieceStaging.awaitingEfficientAction()) {
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
