import 'dart:convert';

Iterable<(int, List<int>)> parse(String input) {
  return LineSplitter().convert(input).map((line) {
    var parts = line.split(": ");
    var targetVal = int.parse(parts[0]);
    var operands = parts[1].split(" ").map(int.parse).toList();
    return (targetVal, operands);
  });
}

bool check(targetVal, i, operands) {
  if (i > operands.length || targetVal < 0) {
    return false;
  } else if (i == operands.length) {
    return targetVal == 0;
  } else {
    return (targetVal % operands[i] == 0 &&
            check(targetVal ~/ operands[i], i + 1, operands)) ||
        check(targetVal - operands[i], i + 1, operands);
  }
}

int answer1(String input) {
  var data = parse(input);
  var acc = 0;
  for (var (targetVal, operands) in data) {
    var possible = check(targetVal, 0, operands.reversed.toList());
    if (possible) {
      acc += targetVal;
    }
  }
  return acc;
}

int concat(int left, int right) {
  int displacement = 1;
  while (right ~/ displacement != 0) {
    displacement *= 10;
  }
  return left * displacement + right;
}

bool check2(targetVal, hold, i, operands) {
  if (i > operands.length || targetVal < hold) {
    return false;
  } else if (i == operands.length) {
    return targetVal == hold;
  } else {
    return check2(targetVal, hold + operands[i], i + 1, operands) ||
        check2(targetVal, hold * operands[i], i + 1, operands) ||
        check2(targetVal, concat(hold, operands[i]), i + 1, operands);
  }
}

int answer2(String input) {
  var data = parse(input);
  var acc = 0;
  for (var (targetVal, operands) in data) {
    var possible = check2(targetVal, operands[0], 1, operands);
    if (possible) {
      acc += targetVal;
    }
  }
  return acc;
}
