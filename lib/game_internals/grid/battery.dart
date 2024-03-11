import 'dart:math';

import 'package:card/game_internals/panel/panel.dart';

class Battery {
  final Panel panel;
  double charge = 0;

  Battery({required this.panel});

  void incrementChargeForFractionOfDay({required int fractionOfDay}) {
    double chargeToAdd = panel.storageCapacity / fractionOfDay;
    charge += chargeToAdd;
    charge = min(charge, panel.storageCapacity.toDouble());
  }
}
