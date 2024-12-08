import "dart:convert";

List<List<int>> parse(String input) {
  return LineSplitter().convert(input).map((line) {
    return line.split(" ").map((word) => int.parse(word)).toList();
  }).toList();
}

bool isSafe(List<int> status, int? skip) {
  if (status.length < 2) {
    return true;
  }

  bool increasing = status[0] < status[1];
  if (skip == 0) {
    increasing = status[1] < status[2];
  } else if (skip == 1) {
    increasing = status[0] < status[2];
  }
  for (int i = 0; i < status.length - 1; i++) {
    var a = status[i];
    var b = status[i + 1];
    if (skip != null) {
      if (skip == i) {
        if (skip == 0) {
          continue;
        }
        a = status[i - 1];
      } else if (skip == i + 1) {
        if (skip == status.length - 1) {
          continue;
        }
        b = status[i + 2];
      }
    }
    var diff = (a - b).abs();
    if (a < b != increasing || !(diff >= 1 && diff <= 3)) {
      return false;
    }
  }
  return true;
}

int answer1(String input) {
  final statuses = parse(input);

  var acc = 0;
  for (var status in statuses) {
    acc += isSafe(status, null) ? 1 : 0;
  }
  return acc;
}

int answer2(String input) {
  final statuses = parse(input);

  var acc = 0;
  for (int i = 0; i < statuses.length; i++) {
    for (int j = 0; j < statuses[i].length; j++) {
      if (isSafe(statuses[i], j)) {
        acc += 1;
        break;
      }
    }
  }
  return acc;
}
