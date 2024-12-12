import 'dart:collection';
import 'dart:convert';

int answer1(String input) {
  List<String> data = LineSplitter().convert(input);
  List<List<bool>> seen = List.generate(
      data.length, (_) => List.generate(data[0].length, (_) => false));

  inBounds(y, x) => y >= 0 && y < data.length && x >= 0 && x < data[0].length;

  var acc = 0;
  for (int i = 0; i < data.length; i++) {
    for (int j = 0; j < data[0].length; j++) {
      if (seen[i][j]) {
        continue;
      }
      final char = data[i][j];
      final q = Queue<(int, int)>();

      var area = 0;
      var perimeter = 0;

      q.add((i, j));
      seen[i][j] = true;
      while (q.isNotEmpty) {
        final (y, x) = q.removeFirst();
        final currentChar = data[y][x];
        // print("$currentChar $y $x");
        if (currentChar == char) {
          area++;
        }

        check(y, x) {
          if (inBounds(y, x) && data[y][x] == char) {
            if (!seen[y][x]) {
              q.add((y, x));
              seen[y][x] = true;
            }
          } else {
            perimeter++;
          }
        }

        check(y + 1, x);
        check(y - 1, x);
        check(y, x + 1);
        check(y, x - 1);
      }

      // print("$char $area $perimeter");
      acc += area * perimeter;
    }
  }
  return acc;
}

int answer2(String input) {
  List<String> data = LineSplitter().convert(input);
  List<List<bool>> seen = List.generate(
      data.length, (_) => List.generate(data[0].length, (_) => false));

  inBounds(y, x) => y >= 0 && y < data.length && x >= 0 && x < data[0].length;

  var acc = 0;
  for (int i = 0; i < data.length; i++) {
    for (int j = 0; j < data[0].length; j++) {
      if (seen[i][j]) {
        continue;
      }
      final char = data[i][j];
      final q = Queue<(int, int)>();

      var area = 0;
      var sides = 0;

      q.add((i, j));
      seen[i][j] = true;
      while (q.isNotEmpty) {
        final (y, x) = q.removeFirst();
        final currentChar = data[y][x];
        if (currentChar == char) {
          area++;
        }

        isChar(y, x) => inBounds(y, x) && data[y][x] == char;

        check(y, x) {
          if (!isChar(y, x)) {
            return true;
          }
          if (!seen[y][x]) {
            q.add((y, x));
            seen[y][x] = true;
          }
          return false;
        }

        var down = check(y + 1, x);
        var up = check(y - 1, x);
        var right = check(y, x + 1);
        var left = check(y, x - 1);
        if (up && left) {
          sides++;
        }
        if (!up && !left && !isChar(y - 1, x - 1)) {
          sides++;
        }
        if (down && left) {
          sides++;
        }
        if (!down && !left && !isChar(y + 1, x - 1)) {
          sides++;
        }
        if (up && right) {
          sides++;
        }
        if (!up && !right && !isChar(y - 1, x + 1)) {
          sides++;
        }
        if (down && right) {
          sides++;
        }
        if (!down && !right && !isChar(y + 1, x + 1)) {
          sides++;
        }
      }

      acc += area * sides;
    }
  }
  return acc;
}
