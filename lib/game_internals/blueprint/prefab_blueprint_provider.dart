import 'dart:async';
import 'dart:math';

import 'package:card/game_internals/blueprint/blueprint.dart';
import 'package:card/game_internals/blueprint/blueprint_builder.dart';
import 'package:card/game_internals/blueprint/blueprint_provider.dart';

class PrefabBlueprintProvider implements BlueprintProvider {
  List<Blueprint> blueprints = [];
  final int blueprintsPerRound;
  final List<Blueprint?> blueprintsForRound = [];
  int _maxForRound = 0;

  final StreamController<void> _playerChanges =
      StreamController<void>.broadcast();

  PrefabBlueprintProvider({required this.blueprintsPerRound}) {
    _maxForRound = blueprintsPerRound;
  }

  Stream<void> get playerChanges => _playerChanges.stream;

  @override
  List<Blueprint?> getBlueprintsForRound() {
    return blueprintsForRound;
    // int endIndex = blueprints.length >= quantity ? quantity : blueprints.length;
    // return blueprints.sublist(0, endIndex);
  }

  @override
  int getRemainingCount() {
    return blueprints.length;
  }

  @override
  void removeBlueprint(Blueprint removed) {
    blueprints.removeWhere((element) => removed.id == element.id);
    int indexInRound = blueprintsForRound.indexOf(removed);
    blueprintsForRound[indexInRound] = null;
    _playerChanges.add(null);
  }

  void addBlueprint(BlueprintBuilder builder) {
    blueprints.add(builder.build());
  }

  @override
  Stream<void> getChangeStream() {
    return playerChanges;
  }

  @override
  String getCurrentRoundData() {
    int nonNullRoundBlueprints =
        blueprintsForRound.where((element) => element != null).length;

    return '$nonNullRoundBlueprints/$_maxForRound';
  }

  @override
  void nextRound() {
    _maxForRound = min(blueprintsPerRound, blueprints.length);
    int endIndex = blueprints.length >= blueprintsPerRound
        ? blueprintsPerRound
        : blueprints.length;
    blueprintsForRound.clear();
    blueprintsForRound.addAll(blueprints.sublist(0, endIndex));
  }
}
