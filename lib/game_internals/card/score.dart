import 'package:card/game_internals/blueprint/blueprint.dart';

class Score {
  final int score;
  final int day;
  final bool win;

  final List<Blueprint> blueprints;

  factory Score(int day, int totalCapacity, List<Blueprint> blueprints) {
    var score = totalCapacity;

    return Score._(score, day, blueprints, blueprints.isEmpty);
  }

  const Score._(this.score, this.day, this.blueprints, this.win);

  @override
  String toString() => 'Score<$score,$day>';
}
