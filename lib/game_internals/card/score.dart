class Score {
  final int score;

  final int day;

  factory Score(int day, int totalCapacity) {
    var score = totalCapacity;

    return Score._(score, day);
  }

  const Score._(this.score, this.day);

  @override
  String toString() => 'Score<$score,$day>';
}
