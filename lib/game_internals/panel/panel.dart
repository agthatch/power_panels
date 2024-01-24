import 'dart:async';

import 'package:async/async.dart';
import 'package:card/game_internals/panel/panel_node.dart';

class Panel {
  final int dimX;
  final int dimY;

  late final List<List<PanelNode>> nodes;

  Panel({required this.dimX, required this.dimY}) {
    nodes = List.generate(dimX, (i) => List.generate(dimY, (j) => PanelNode()));
  }

  final StreamController<void> _playerChanges =
      StreamController<void>.broadcast();

  final StreamController<void> _remoteChanges =
      StreamController<void>.broadcast();

  /// A [Stream] that fires an event every time any change to this area is made.
  Stream<void> get allChanges =>
      StreamGroup.mergeBroadcast([remoteChanges, playerChanges]);

  /// A [Stream] that fires an event every time a change is made _locally_,
  /// by the player.
  Stream<void> get playerChanges => _playerChanges.stream;

  /// A [Stream] that fires an event every time a change is made _remotely_,
  /// by another player.
  Stream<void> get remoteChanges => _remoteChanges.stream;
}
