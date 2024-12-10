import 'dart:collection';
import 'dart:convert';

int bfs(List<List<int>> grid, int x, int y) {
  var q = Queue<(int, int, int)>();
  q.add((0, x, y));
  var found = <(int, int)>{};

  inBounds(x, y) => x >= 0 && x < grid[0].length && y >= 0 && y < grid.length;

  while (q.isNotEmpty) {
    var (val, x, y) = q.removeFirst();
    if (val == 9) {
      found.add((x, y));
      continue;
    }

    if (inBounds(x + 1, y) && grid[y][x + 1] == val + 1) {
      q.add((val + 1, x + 1, y));
    }
    if (inBounds(x - 1, y) && grid[y][x - 1] == val + 1) {
      q.add((val + 1, x - 1, y));
    }
    if (inBounds(x, y + 1) && grid[y + 1][x] == val + 1) {
      q.add((val + 1, x, y + 1));
    }
    if (inBounds(x, y - 1) && grid[y - 1][x] == val + 1) {
      q.add((val + 1, x, y - 1));
    }
  }
  return found.length;
}

int bfsDuplicates(List<List<int>> grid, int x, int y) {
  var q = Queue<(int, int, int)>();
  q.add((0, x, y));

  inBounds(x, y) => x >= 0 && x < grid[0].length && y >= 0 && y < grid.length;

  var acc = 0;
  while (q.isNotEmpty) {
    var (val, x, y) = q.removeFirst();
    if (val == 9) {
      acc++;
      continue;
    }

    if (inBounds(x + 1, y) && grid[y][x + 1] == val + 1) {
      q.add((val + 1, x + 1, y));
    }
    if (inBounds(x - 1, y) && grid[y][x - 1] == val + 1) {
      q.add((val + 1, x - 1, y));
    }
    if (inBounds(x, y + 1) && grid[y + 1][x] == val + 1) {
      q.add((val + 1, x, y + 1));
    }
    if (inBounds(x, y - 1) && grid[y - 1][x] == val + 1) {
      q.add((val + 1, x, y - 1));
    }
  }
  return acc;
}

List<List<int>> parse(String input) {
  return LineSplitter()
      .convert(input)
      .map((line) => line.split("").map(int.parse).toList())
      .toList();
}

int answer1(String input) {
  var grid = parse(input);

  var acc = 0;
  for (int y = 0; y < grid.length; y++) {
    for (int x = 0; x < grid[0].length; x++) {
      if (grid[y][x] == 0) {
        acc += bfs(grid, x, y);
      }
    }
  }

  return acc;
}

int answer2(String input) {
  var grid = parse(input);

  var acc = 0;
  for (int y = 0; y < grid.length; y++) {
    for (int x = 0; x < grid[0].length; x++) {
      if (grid[y][x] == 0) {
        acc += bfsDuplicates(grid, x, y);
      }
    }
  }

  return acc;
}
