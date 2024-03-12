import 'dart:async';
import 'dart:math';

import 'package:card/game_internals/panel/panel.dart';

class Battery {
  final Panel panel;
  double _charge = 0;

  final StreamController<void> _playerChanges =
      StreamController<void>.broadcast();

  Stream<void> get playerChanges => _playerChanges.stream;

  Battery({required this.panel});

  double get chargePercent => _charge / panel.storageCapacity.toDouble();

  double get charge => _charge;

  void incrementChargeForFractionOfDay({required int fractionOfDay}) {
    double chargeToAdd = panel.storageCapacity / fractionOfDay;
    _charge += chargeToAdd;
    _charge = min(_charge, panel.storageCapacity.toDouble());
    _playerChanges.add(null);
  }

  void setCharge(double charge) {
    _charge = charge;
    _playerChanges.add(null);
  }

  void useCharge(double chargeToUse) {
    _charge -= chargeToUse;
    _playerChanges.add(null);
  }
}
