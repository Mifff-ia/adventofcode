import 'dart:convert';

int answer1(String input) {
  var isAlNum = RegExp(r'^[a-zA-Z0-9]$');
  Map<String, List<(int, int)>> locs = {};
  var lines = LineSplitter().convert(input);
  for (int y = 0; y < lines.length; y++) {
    for (int x = 0; x < lines[0].length; x++) {
      if (isAlNum.hasMatch(lines[y][x])) {
        locs.update(lines[y][x], (list) {
          list.add((x, y));
          return list;
        }, ifAbsent: () => [(x, y)]);
      }
    }
  }

  inBounds(coord) =>
      coord.$1 >= 0 &&
      coord.$1 < lines[0].length &&
      coord.$2 >= 0 &&
      coord.$2 < lines.length;

  Set<(int, int)> antinodes = {};
  for (var group in locs.values) {
    for (int i = 0; i < group.length; i++) {
      for (int j = i + 1; j < group.length; j++) {
        var xDiff = group[j].$1 - group[i].$1;
        var yDiff = group[j].$2 - group[i].$2;
        var jAntinode = (group[j].$1 + xDiff, group[j].$2 + yDiff);
        var iAntinode = (group[i].$1 - xDiff, group[i].$2 - yDiff);
        if (inBounds(iAntinode)) {
          antinodes.add(iAntinode);
        }
        if (inBounds(jAntinode)) {
          antinodes.add(jAntinode);
        }
      }
    }
  }
  return antinodes.length;
}

int answer2(String input) {
  var isAlNum = RegExp(r'^[a-zA-Z0-9]$');
  Map<String, List<(int, int)>> locs = {};
  var lines = LineSplitter().convert(input);
  for (int y = 0; y < lines.length; y++) {
    for (int x = 0; x < lines[0].length; x++) {
      if (isAlNum.hasMatch(lines[y][x])) {
        locs.update(lines[y][x], (list) {
          list.add((x, y));
          return list;
        }, ifAbsent: () => [(x, y)]);
      }
    }
  }

  inBounds(coord) =>
      coord.$1 >= 0 &&
      coord.$1 < lines[0].length &&
      coord.$2 >= 0 &&
      coord.$2 < lines.length;

  Set<(int, int)> antinodes = {};
  for (var group in locs.values) {
    for (int i = 0; i < group.length; i++) {
      for (int j = i + 1; j < group.length; j++) {
        var xDiff = group[j].$1 - group[i].$1;
        var yDiff = group[j].$2 - group[i].$2;
        var iAntinode = group[i];
        while (inBounds(iAntinode)) {
          antinodes.add(iAntinode);
          iAntinode = (iAntinode.$1 - xDiff, iAntinode.$2 - yDiff);
        }
        var jAntinode = group[j];
        while (inBounds(jAntinode)) {
          antinodes.add(jAntinode);
          jAntinode = (jAntinode.$1 + xDiff, jAntinode.$2 + yDiff);
        }
      }
    }
  }
  return antinodes.length;
}
