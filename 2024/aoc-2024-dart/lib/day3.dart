import 'dart:core';

int answer1(String input) {
  var regex = RegExp(r"(mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\))");
  var acc = 0;
  for (var match in regex.allMatches(input)) {
    if (match[1]!.startsWith("mul")) {
      acc += int.parse(match[2]!) * int.parse(match[3]!);
    }
  }
  return acc;
}

int answer2(String input) {
  var regex = RegExp(r"(mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\))");
  var acc = 0;
  var doMul = true;
  for (var match in regex.allMatches(input)) {
    var function = match[1]!;
    if (function.startsWith("mul") && doMul) {
      acc += int.parse(match[2]!) * int.parse(match[3]!);
    } else if (function.startsWith("don't")) {
      doMul = false;
    } else if (function.startsWith("do")) {
      doMul = true;
    }
  }
  return acc;
}
