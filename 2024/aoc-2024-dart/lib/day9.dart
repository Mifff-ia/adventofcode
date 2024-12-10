import 'dart:convert';
import 'dart:math';

(List<int>, List<int>) parse(String input) {
  var filled = <int>[];
  var free = <int>[];
  var cleanedLine = LineSplitter().convert(input)[0];
  for (int i = 0; i < cleanedLine.length; i++) {
    int val = int.parse(cleanedLine[i]);
    if (i % 2 == 0) {
      filled.add(val);
    } else {
      free.add(val);
    }
  }
  return (filled, free);
}

int sumRange(int offset, int width) {
  var acc = 0;
  for (int i = offset; i < offset + width; i++) {
    acc += i;
  }
  return acc;
}

int answer1(String input) {
  var (filled, free) = parse(input);
  var left = 0;
  var right = filled.length - 1;
  var acc = 0;
  var isAtLeft = true;
  var offset = 0;
  for (int i = 0; left <= right;) {
    if (isAtLeft) {
      acc += left * sumRange(offset, filled[left]);
      offset += filled[left];
      left++;
      isAtLeft = false;
    } else {
      var amount = min(free[i], filled[right]);
      acc += right * sumRange(offset, amount);
      offset += amount;
      free[i] -= amount;
      filled[right] -= amount;
      if (free[i] == 0) {
        isAtLeft = true;
        i++;
      }
      if (filled[right] == 0) {
        right--;
      }
    }
  }
  return acc;
}

int answer2(String input) {
  return 0;
}
