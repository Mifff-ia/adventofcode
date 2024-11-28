import 'dart:convert';

int findRequiredNumber(RegExp regex, String line) {
  var matches = regex.allMatches(line);
  var firstMatch = matches.first.group(0)!;
  var firstDigit = int.parse(firstMatch);
  var lastMatch = matches.last.group(0)!;
  var lastDigit = int.parse(lastMatch);
  return firstDigit * 10 + lastDigit;
}

int answer1(String input) {
  var regex = RegExp(r"\d");
  return LineSplitter()
      .convert(input)
      .map((line) => findRequiredNumber(regex, line))
      .reduce((accumulator, value) => accumulator + value);
}

/// Answer stolen from https://github.com/fuglede/adventofcode/blob/master/2023/day01/solutions.py
/// I already solved this in rust and I was just looking at alternate solutions.
/// This one is honestly the most interesting.
int answer2(String input) {
  var regex = RegExp(r"\d");
  return LineSplitter()
      .convert(input)
      .map((line) => line
          .replaceAll("one", "one1one")
          .replaceAll("two", "two2two")
          .replaceAll("three", "three3three")
          .replaceAll("four", "four4four")
          .replaceAll("five", "five5five")
          .replaceAll("six", "six6six")
          .replaceAll("seven", "seven7seven")
          .replaceAll("eight", "eight8eight")
          .replaceAll("nine", "nine9nine"))
      .map((line) => findRequiredNumber(regex, line))
      .reduce((accumulator, value) => accumulator + value);
}
