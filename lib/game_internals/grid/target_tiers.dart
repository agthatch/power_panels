class TargetTiers {
  final Map<int, int> targetbyLowerBound;
  final int maxValue;
  final int maxBound;

  TargetTiers(
      {required this.maxValue,
      required this.maxBound,
      required this.targetbyLowerBound});

  int getTargetForNight(int nightNumber) {
    if (nightNumber >= maxBound) {
      return maxValue;
    }
    int previousTarget = 0;
    for (MapEntry<int, int> entry in targetbyLowerBound.entries) {
      if (entry.key > nightNumber) {
        return previousTarget;
      }
      previousTarget = entry.value;
    }

    return 0;
  }
}

class TargetTiersBuilder {
  Map<int, int> targetbyLowerBound = {};

  TargetTiersBuilder withTier({required int lowerBound, required int target}) {
    targetbyLowerBound.putIfAbsent(lowerBound, () => target);
    return this;
  }

  TargetTiers build() {
    Map<int, int> sortedtargetbyLowerBound = {};

    final List<int> sortedKeys = targetbyLowerBound.keys.toList()..sort();

    for (int key in sortedKeys) {
      sortedtargetbyLowerBound.putIfAbsent(key, () => targetbyLowerBound[key]!);
    }

    return TargetTiers(
        maxValue: targetbyLowerBound[sortedKeys.last]!,
        maxBound: sortedKeys.last,
        targetbyLowerBound: targetbyLowerBound);
  }
}
