import 'package:card/game_internals/card/player.dart';
import 'package:card/game_internals/upcycling/upcycle_controller.dart';
import 'package:card/play_session/card/player_hand_widget.dart';
import 'package:card/play_session/upcycler/upcycler_widget.dart';
import 'package:flutter/material.dart';

class HandAnimationWidget extends StatelessWidget {
  final Player player;
  final UpcycleController upcycleController;

  const HandAnimationWidget(
      {super.key, required this.player, required this.upcycleController});
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
                height:
                    determineTrayHeight(), // Update height based on constraints
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                  color: Colors.blueGrey, // Example color
                  borderRadius:
                      BorderRadius.circular(8), // Example border radius
                ),
                child: Column(
                  children: [
                    PlayerHandWidget(
                      player: player,
                      upcycleController: upcycleController,
                    ),
                    if (upcycleController.shouldShow)
                      UpcyclerWidget(
                        controller: upcycleController,
                      )
                  ],
                ),
              );
            },
          );
        });
  }

  double determineTrayHeight() {
    double extraHeight = 000.0;
    if (!player.handIsExpanded) {
      return 100.0 + extraHeight;
    }

    if (upcycleController.shouldShow) {
      return 360.0 + extraHeight;
    }
    return 200.0 + extraHeight;
  }
}
