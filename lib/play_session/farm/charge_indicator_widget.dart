import 'package:card/game_internals/grid/battery.dart';
import 'package:flutter/material.dart';

class ChargeIndicatorWidget extends StatefulWidget {
  final Battery battery;

  const ChargeIndicatorWidget({super.key, required this.battery});

  @override
  State<ChargeIndicatorWidget> createState() => _ChargeIndicatorWidgetState();
}

class _ChargeIndicatorWidgetState extends State<ChargeIndicatorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  double _progressValue = 0.5;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 10,
      child: RotatedBox(
        quarterTurns: -1,
        child: StreamBuilder(
            stream: widget.battery.playerChanges,
            builder: (context, snapshot) {
              _animationController.forward();

              _progressValue = widget.battery.chargePercent;
              // _animationController.reset();
              _animationController.forward();

              return AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: _progressValue,
                    backgroundColor: Colors.grey[300],
                    // color: _getColor(widget.battery.chargePercent),
                    valueColor: AlwaysStoppedAnimation<Color>(
                        _getColor(widget.battery.chargePercent)),
                  );
                },
              );
            }),
      ),
    );
  }

  Color _getColor(double chargePercent) {
    if (chargePercent < 0.34) {
      return Colors.red;
    } else if (chargePercent < 0.67) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }
}
