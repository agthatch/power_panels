import 'package:card/game_internals/blueprint/blueprint.dart';

abstract class BlueprintProvider {
  List<Blueprint> getNextBlueprints(int quantity);
  int getRemainingCount();
  void removeBlueprint(Blueprint removed);
}
