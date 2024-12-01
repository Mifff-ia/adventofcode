import "dart:convert";

(List<int>, List<int>) parse(String input) {
  var left = <int>[];
  var right = <int>[];

  LineSplitter().convert(input).forEach((line) {
    final split = line.split("   ");
    left.add(int.parse(split[0]));
    right.add(int.parse(split[1]));
  });

  return (left, right);
}

int answer1(String input) {
  final (left, right) = parse(input);
  left.sort();
  right.sort();
  var acc = 0;
  for (var i = 0; i < left.length; i++) {
    acc += (left[i] - right[i]).abs();
  }
  return acc;
}

int answer2(String input) {
  final (left, right) = parse(input);
  left.sort();
  right.sort();

  var leftMap = <int, int>{};
  var rightMap = <int, int>{};

  for (int i = 0; i < left.length; i++) {
    leftMap.update(left[i], (val) => val + 1, ifAbsent: () => 1);
    rightMap.update(right[i], (val) => val + 1, ifAbsent: () => 1);
  }

  var acc = 0;
  leftMap.forEach((k, v) {
    acc += k * v * (rightMap[k] ?? 0);
  });
  return acc;
}
