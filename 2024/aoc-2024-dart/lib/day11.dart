import 'dart:math';

List<int> parse(String input) {
  return input.split(" ").map(int.parse).toList();
}

int digits(int num) {
  var count = 0;
  while (num != 0) {
    num ~/= 10;
    count++;
  }
  return count;
}

int blink(List<int> startSeed, int numBlinks) {
  var counts = <int, int>{};
  for (var val in startSeed) {
    counts.update(val, (count) => count + 1, ifAbsent: () => 1);
  }

  for (int i = 0; i < numBlinks; i++) {
    var updatedCounts = <int, int>{};
    counts.forEach((val, count) {
      var d = digits(val);
      if (val == 0) {
        updatedCounts.update(1, (newCount) => newCount + count,
            ifAbsent: () => count);
      } else if (d % 2 == 0) {
        updatedCounts.update(
            val ~/ pow(10, d ~/ 2), (newCount) => newCount + count,
            ifAbsent: () => count);
        updatedCounts.update(
            (val % pow(10, d ~/ 2)).toInt(), (newCount) => newCount + count,
            ifAbsent: () => count);
      } else {
        updatedCounts.update(val * 2024, (newCount) => newCount + count,
            ifAbsent: () => count);
      }
    });
    counts = updatedCounts;
  }

  return counts.entries
      .map((entry) => entry.value)
      .reduce((acc, curr) => acc + curr);
}

int answer1(String input) {
  return blink(parse(input), 25);
}

int answer2(String input) {
  return blink(parse(input), 75);
}
