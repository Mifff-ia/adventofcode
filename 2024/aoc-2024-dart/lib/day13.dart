import 'dart:convert';

List<(Map<String, (int, int)>, (int, int))> parse(String input) {
  return input.split("\n\n").map((chunk) {
    final lines = LineSplitter().convert(chunk);
    final buttonMatcher = RegExp(r"^Button (\w): X\+(\d+), Y\+(\d+)$");
    var buttons = <String, (int, int)>{};

    extractButton(line) {
      final match = buttonMatcher.firstMatch(line)!;
      var buttonName = match[1]!;
      var x = int.parse(match[2]!);
      var y = int.parse(match[3]!);
      buttons[buttonName] = (x, y);
    }

    extractButton(lines[0]);
    extractButton(lines[1]);

    final prizeMatcher = RegExp(r"^Prize: X=(\d+), Y=(\d+)");
    final match = prizeMatcher.firstMatch(lines[2])!;
    final prize = (int.parse(match[1]!), int.parse(match[2]!));

    return (buttons, prize);
  }).toList();
}

int answer1(String input) {
  var data = parse(input);
  return data.map((clawMachine) {
    final (ax, ay) = clawMachine.$1['A']!;
    final (bx, by) = clawMachine.$1['B']!;

    final (cx, cy) = clawMachine.$2;

    final mNumerator = (cx * by - bx * cy);
    final mDenominator = (ax * by - ay * bx);

    if (mNumerator % mDenominator != 0) {
      return 0;
    }

    final m = mNumerator ~/ mDenominator;

    final nNumerator = (cx - m * ax);
    if (nNumerator % bx != 0) {
      return 0;
    }

    final n = nNumerator ~/ bx;

    return m * 3 + n;
  }).reduce((x, y) => x + y);
}

int answer2(String input) {
  var data = parse(input);
  return data.map((clawMachine) {
    final (ax, ay) = clawMachine.$1['A']!;
    final (bx, by) = clawMachine.$1['B']!;

    var (cx, cy) = clawMachine.$2;
    cx += 10000000000000;
    cy += 10000000000000;

    final mNumerator = (cx * by - bx * cy);
    final mDenominator = (ax * by - ay * bx);

    if (mNumerator % mDenominator != 0) {
      return 0;
    }

    final m = mNumerator ~/ mDenominator;

    final nNumerator = (cx - m * ax);
    if (nNumerator % bx != 0) {
      return 0;
    }

    final n = nNumerator ~/ bx;

    return m * 3 + n;
  }).reduce((x, y) => x + y);
}
