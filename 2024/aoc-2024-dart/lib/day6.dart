import 'dart:convert';

enum Direction {
  up,
  down,
  left,
  right,
}

int answer1(String input) {
  var lines =
      LineSplitter().convert(input).map((elem) => elem.split("")).toList();
  var x = -1;
  var y = -1;
  var direction = Direction.up;
  for (int i = 0; i < lines.length; i++) {
    for (int j = 0; j < lines[0].length; j++) {
      if (lines[i][j] == '^') {
        y = i;
        x = j;
      }
    }
  }

  var acc = 0;
  while (x >= 0 && x < lines[0].length && y >= 0 && y < lines.length) {
    switch (direction) {
      case Direction.up:
        if (y != 0 && lines[y - 1][x] == '#') {
          direction = Direction.right;
        } else {
          if (lines[y][x] != 'X') {
            lines[y][x] = 'X';
            acc += 1;
          }
          y = y - 1;
        }
        break;
      case Direction.right:
        if (x != lines[0].length - 1 && lines[y][x + 1] == '#') {
          direction = Direction.down;
        } else {
          if (lines[y][x] != 'X') {
            lines[y][x] = 'X';
            acc += 1;
          }
          x = x + 1;
        }
        break;
      case Direction.down:
        if (y != lines.length - 1 && lines[y + 1][x] == '#') {
          direction = Direction.left;
        } else {
          if (lines[y][x] != 'X') {
            lines[y][x] = 'X';
            acc += 1;
          }
          y = y + 1;
        }
        break;
      case Direction.left:
        if (x != 0 && lines[y][x - 1] == '#') {
          direction = Direction.up;
        } else {
          if (lines[y][x] != 'X') {
            lines[y][x] = 'X';
            acc += 1;
          }
          x = x - 1;
        }
        break;
    }
  }
  return acc;
}

const wall = 16;
const up = 1;
const down = 2;
const left = 4;
const right = 8;

int answer2(String input) {
  var l = LineSplitter()
      .convert(input)
      .map((elem) => elem.split("").map((char) => char.codeUnitAt(0)).toList())
      .toList();
  var startX = -1;
  var startY = -1;
  for (int i = 0; i < l.length; i++) {
    for (int j = 0; j < l[0].length; j++) {
      if (l[i][j] == '^'.codeUnitAt(0)) {
        startY = i;
        startX = j;
        l[i][j] = 0;
      } else if (l[i][j] == '#'.codeUnitAt(0)) {
        l[i][j] = wall;
      } else {
        l[i][j] = 0;
      }
    }
  }

  var acc = 0;
  for (int i = 0; i < l.length; i++) {
    for (int j = 0; j < l[0].length; j++) {
      var lines = [
        for (var sublist in l) [...sublist]
      ];
      if (lines[i][j] == wall || (i == startY && j == startX)) {
        continue;
      }
      lines[i][j] = wall;
      if (hasLoop(startX, startY, lines)) {
        acc += 1;
      }
    }
  }
  return acc;
}

bool hasLoop(int x, int y, List<List<int>> lines) {
  var direction = Direction.up;
  while (x >= 0 && x < lines[0].length && y >= 0 && y < lines.length) {
    // for (var line in lines) {
    //   print(line.map((elem) {
    //     if (elem == wall) {
    //       return "#";
    //     } else if (elem != 0) {
    //       return elem.toRadixString(16);
    //     } else {
    //       return ".";
    //     }
    //   }).join(""));
    // }
    switch (direction) {
      case Direction.up:
        lines[y][x] |= up;
        if (y != 0 && lines[y - 1][x] == wall) {
          direction = Direction.right;
        } else if (y != 0 && lines[y - 1][x] & up != 0) {
          return true;
        } else {
          y = y - 1;
        }
        break;
      case Direction.right:
        lines[y][x] |= right;
        if (x != lines[0].length - 1 && lines[y][x + 1] == wall) {
          direction = Direction.down;
        } else if (x != lines[0].length - 1 && lines[y][x + 1] & right != 0) {
          return true;
        } else {
          x = x + 1;
        }
        break;
      case Direction.down:
        lines[y][x] |= down;
        if (y != lines.length - 1 && lines[y + 1][x] == wall) {
          direction = Direction.left;
        } else if (y != lines.length - 1 && lines[y + 1][x] & down != 0) {
          return true;
        } else {
          y = y + 1;
        }
        break;
      case Direction.left:
        lines[y][x] |= left;
        if (x != 0 && lines[y][x - 1] == wall) {
          direction = Direction.up;
        } else if (x != 0 && lines[y][x - 1] & left != 0) {
          return true;
        } else {
          x = x - 1;
        }
        break;
    }
  }
  return false;
}
