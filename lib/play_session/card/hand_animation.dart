import 'package:card/game_internals/card/player.dart';
import 'package:card/play_session/card/player_hand_widget.dart';
import 'package:flutter/material.dart';

class HandAnimationWidget extends StatelessWidget {
  final Player player;

  const HandAnimationWidget({super.key, required this.player});
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: player,
        builder: (context, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 500), // Animation duration
                width:
                    constraints.maxWidth, // Update width based on constraints
                height: player.handIsExpanded
                    ? 200.0
                    : 100.0, // Update height based on constraints
                decoration: BoxDecoration(
                  color: Colors.blue, // Example color
                  borderRadius:
                      BorderRadius.circular(8), // Example border radius
                ),
                child: PlayerHandWidget(player: player),
              );
            },
          );
        });
  }
}
