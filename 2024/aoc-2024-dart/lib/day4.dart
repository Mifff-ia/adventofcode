import 'dart:convert';

bool isSpellingXmasInEitherOrder(String str) {
  return str == "XMAS" || str == "SAMX";
}

int answer1(String input) {
  final lines = LineSplitter().convert(input);
  var acc = 0;
  for (int i = 0; i < lines.length; i++) {
    for (int j = 0; j < lines[0].length; j++) {
      if (j - 3 >= 0 && i + 3 < lines.length) {
        acc += isSpellingXmasInEitherOrder(
                "${lines[i][j]}${lines[i + 1][j - 1]}${lines[i + 2][j - 2]}${lines[i + 3][j - 3]}")
            ? 1
            : 0;
      }
      if (j + 3 < lines[0].length) {
        acc += isSpellingXmasInEitherOrder(
                "${lines[i][j]}${lines[i][j + 1]}${lines[i][j + 2]}${lines[i][j + 3]}")
            ? 1
            : 0;
        if (i + 3 < lines.length) {
          acc += isSpellingXmasInEitherOrder(
                  "${lines[i][j]}${lines[i + 1][j + 1]}${lines[i + 2][j + 2]}${lines[i + 3][j + 3]}")
              ? 1
              : 0;
        }
      }
      if (i + 3 < lines.length) {
        acc += isSpellingXmasInEitherOrder(
                "${lines[i][j]}${lines[i + 1][j]}${lines[i + 2][j]}${lines[i + 3][j]}")
            ? 1
            : 0;
      }
    }
  }
  return acc;
}

int answer2(String input) {
  final lines = LineSplitter().convert(input);
  var acc = 0;
  for (int i = 0; i < lines.length; i++) {
    for (int j = 0; j < lines[0].length; j++) {
      if (lines[i][j] == 'A' &&
          i - 1 >= 0 &&
          i + 1 < lines.length &&
          j - 1 >= 0 &&
          j + 1 < lines[0].length) {
        // print("${lines[i - 1][j - 1]}${lines[i - 1][j]}${lines[i - 1][j + 1]}");
        // print("${lines[i][j - 1]}${lines[i][j]}${lines[i][j + 1]}");
        // print("${lines[i + 1][j - 1]}${lines[i + 1][j]}${lines[i + 1][j + 1]}");
        var ltor = "${lines[i - 1][j - 1]}${lines[i + 1][j + 1]}";
        var rtol = "${lines[i - 1][j + 1]}${lines[i + 1][j - 1]}";
        var isXMas =
            (ltor == "MS" || ltor == "SM") && (rtol == "MS" || rtol == "SM");
        print(isXMas);
        acc += isXMas ? 1 : 0;
      }
    }
  }
  return acc;
}
