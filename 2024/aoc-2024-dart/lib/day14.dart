const gridHeight = 103;
const gridWidth = 101;

List<({({int x, int y}) p, ({int x, int y}) v})> parse(String input) {
  var regex = RegExp(r"p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)");
  return regex.allMatches(input).map((match) {
    return (
      p: (
        x: int.parse(match[1]!),
        y: int.parse(match[2]!),
      ),
      v: (
        x: int.parse(match[3]!),
        y: int.parse(match[4]!),
      ),
    );
  }).toList();
}

int answer1(String input) {
  final data = parse(input);
  var topLeft = 0;
  var topRight = 0;
  var botLeft = 0;
  var botRight = 0;
  for (var robot in data) {
    final (x, y) = (
      (robot.p.x + robot.v.x * 100) % gridWidth,
      (robot.p.y + robot.v.y * 100) % gridHeight
    );
    final top = y < gridHeight ~/ 2;
    final bot = y > gridHeight ~/ 2;
    final left = x < gridWidth ~/ 2;
    final right = x > gridWidth ~/ 2;

    if (top && left) {
      topLeft++;
    } else if (top && right) {
      topRight++;
    } else if (bot && left) {
      botLeft++;
    } else if (bot && right) {
      botRight++;
    }
  }
  return topLeft * topRight * botLeft * botRight;
}

int answer2(String input) {
  final data = parse(input);
  var i = 0;
  tick:
  while (true) {
    var seen = <(int, int)>{};
    for (var robot in data) {
      final point = (
        (robot.p.x + robot.v.x * i) % gridWidth,
        (robot.p.y + robot.v.y * i) % gridHeight
      );
      if (seen.contains(point)) {
        i++;
        continue tick;
      } else {
        seen.add(point);
      }
    }
    return i;
  }
}
