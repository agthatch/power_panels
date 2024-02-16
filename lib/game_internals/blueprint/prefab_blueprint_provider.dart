import 'dart:async';

import 'package:card/game_internals/blueprint/blueprint.dart';
import 'package:card/game_internals/blueprint/blueprint_builder.dart';
import 'package:card/game_internals/blueprint/blueprint_provider.dart';

class PrefabBlueprintProvider implements BlueprintProvider {
  List<Blueprint> blueprints = [];

  final StreamController<void> _playerChanges =
      StreamController<void>.broadcast();

  Stream<void> get playerChanges => _playerChanges.stream;

  @override
  List<Blueprint> getNextBlueprints(int quantity) {
    int endIndex = blueprints.length >= quantity ? quantity : blueprints.length;
    return blueprints.sublist(0, endIndex);
  }

  @override
  int getRemainingCount() {
    return blueprints.length;
  }

  @override
  void removeBlueprint(Blueprint removed) {
    blueprints.removeWhere((element) => removed.id == element.id);
    _playerChanges.add(null);
  }

  void addBlueprint(BlueprintBuilder builder) {
    blueprints.add(builder.build());
  }

  @override
  Stream<void> getChangeStream() {
    return playerChanges;
  }
}
