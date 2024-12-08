import 'dart:convert';

(Map<String, Set<String>>, List<List<String>>) parse(String input) {
  var parts = input.split("\n\n");
  var map = <String, Set<String>>{};
  LineSplitter().convert(parts[0]).forEach((rule) {
    var ordering = rule.split("|");
    var before = ordering[0];
    var after = ordering[1];
    map.update(before, (s) {
      s.add(after);
      return s;
    }, ifAbsent: () => {after});
  });
  var updates =
      LineSplitter().convert(parts[1]).map((line) => line.split(",")).toList();
  return (map, updates);
}

int answer1(String input) {
  var (map, list) = parse(input);
  var acc = 0;
  for (var update in list) {
    var valid = true;
    for (int i = 0; i < update.length; i++) {
      for (int j = i + 1; j < update.length; j++) {
        if ((map[update[j]] ?? {}).contains(update[i])) {
          valid = false;
          break;
        }
      }
    }
    if (valid) {
      acc += int.parse(update[update.length ~/ 2]);
    }
  }
  return acc;
}

int answer2(String input) {
  var (map, list) = parse(input);
  var acc = 0;
  for (var update in list) {
    var invalid = false;
    for (int i = 0; i < update.length; i++) {
      for (int j = i + 1; j < update.length; j++) {
        while ((map[update[j]] ?? {}).contains(update[i])) {
          invalid = true;
          var temp = update[i];
          update[i] = update[j];
          update[j] = temp;
        }
      }
    }
    if (invalid) {
      acc += int.parse(update[update.length ~/ 2]);
    }
  }
  return acc;
}
