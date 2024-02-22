import 'package:card/game_internals/piece/playing_piece.dart';
import 'package:card/play_session/playing_piece_widget.dart';
import 'package:flutter/material.dart';

class PulsingPieceWidget extends StatefulWidget {
  final PlayingPiece piece;

  const PulsingPieceWidget({super.key, required this.piece});

  @override
  PulsingPieceWidgetState createState() => PulsingPieceWidgetState();
}

class PulsingPieceWidgetState extends State<PulsingPieceWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Adjust duration as needed
    );

    _animation = Tween<double>(
      begin: 1.0, // Start from 50% opacity
      end: 0.5, // End at 100% opacity
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Use a linear curve
    ));

    // Start animation when the widget is first built
    if (widget.piece.isStaged) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant PulsingPieceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if animation needs to be started or stopped based on the boolean value
    if (widget.piece.isStaged) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Center(child: PlayingPieceWidget(widget.piece)),
    );
  }
}
