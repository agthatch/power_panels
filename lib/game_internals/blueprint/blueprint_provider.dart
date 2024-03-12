import 'package:card/game_internals/blueprint/blueprint.dart';

abstract class BlueprintProvider {
  List<Blueprint?> getBlueprintsForRound();
  void nextRound();
  int getRemainingCount();
  void removeBlueprint(Blueprint removed);
  Stream<void> getChangeStream();
  String getCurrentRoundData();

  List<Blueprint> getAll();
}
