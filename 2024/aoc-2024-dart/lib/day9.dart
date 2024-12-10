import 'dart:convert';

(List<int>, List<int>) parse(String input) {
  var filled = <int>[];
  var all = <int>[];
  var cleanedLine = LineSplitter().convert(input)[0];
  for (int i = 0; i < cleanedLine.length; i++) {
    int val = int.parse(cleanedLine[i]);
    if (i % 2 == 0) {
      filled.add(val);
    }
    all.add(val);
  }
  return (filled, all);
}

int sumRange(int offset, int width) {
  var acc = 0;
  for (int i = offset; i < offset + width; i++) {
    acc += i;
  }
  return acc;
}

int answer1(String input) {
  var (filled, all) = parse(input);
  var left = 0;
  var right = filled.length - 1;
  var acc = 0;
  var isAtLeft = true;
  var offset = 0;
  for (int i = 0; i < all.length && left <= right; i++) {
    while (all[i] != 0) {
      if (isAtLeft) {
        if (filled[left] == 0) {
          break;
        }
        if (all[i] <= filled[left]) {
          print("left $left offset $offset all ${all[i]}");
          acc += left * sumRange(offset, all[i]);
          print("$left ${sumRange(offset, all[i])}");
          offset += all[i];
          filled[left] -= all[i];
          all[i] = 0;
          isAtLeft = !isAtLeft;
          if (all[i] == filled[left]) {
            left++;
          }
        } else {
          print("left $left offset $offset filled ${filled[left]}");
          acc += left * sumRange(offset, filled[left]);
          print("$left ${sumRange(offset, filled[left])}");
          offset += filled[left];
          all[i] -= filled[left];
          filled[left] = 0;
          left++;
        }
      } else {
        if (all[i] <= filled[right]) {
          print("right $right offset $offset all ${all[i]}");
          acc += right * sumRange(offset, all[i]);
          print("$right ${sumRange(offset, all[right])}");
          offset += all[i];
          filled[right] -= all[i];
          all[i] = 0;
          isAtLeft = !isAtLeft;
          if (all[i] == filled[right]) {
            right--;
          }
        } else {
          print("right $right offset $offset filled ${filled[right]}");
          acc += right * sumRange(offset, filled[right]);
          print("$right ${sumRange(offset, filled[right])}");
          offset += filled[right];
          all[i] -= filled[right];
          filled[right] = 0;
          right--;
        }
      }
    }
  }
  print("$filled, $acc");
  return acc;
}

int answer2(String input) {
  return 0;
}
