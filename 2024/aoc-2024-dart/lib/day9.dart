import 'dart:convert';
import 'dart:math';

(List<int>, List<int>, List<int>, List<int>) parse(String input) {
  var base = 0;
  var filled = <int>[];
  var filledBases = <int>[];
  var free = <int>[];
  var freeBases = <int>[];
  var cleanedLine = LineSplitter().convert(input)[0];
  for (int i = 0; i < cleanedLine.length; i++) {
    int val = int.parse(cleanedLine[i]);
    if (i % 2 == 0) {
      filled.add(val);
      filledBases.add(base);
      base += val;
    } else {
      free.add(val);
      freeBases.add(base);
      base += val;
    }
  }
  return (filled, filledBases, free, freeBases);
}

int sumRange(int offset, int width) {
  var acc = 0;
  for (int i = offset; i < offset + width; i++) {
    acc += i;
  }
  return acc;
}

int answer1(String input) {
  var (filled, _, free, _) = parse(input);
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
  var (filled, filledBases, free, freeBases) = parse(input);

  var acc = 0;
  for (int i = filled.length - 1; i >= 0; i--) {
    var relocated = false;
    for (int j = 0; freeBases[j] < filledBases[i]; j++) {
      if (free[j] >= filled[i]) {
        acc += i * sumRange(freeBases[j], filled[i]);
        free[j] -= filled[i];
        freeBases[j] += filled[i];
        relocated = true;
        break;
      }
    }
    if (!relocated) {
      acc += i * sumRange(filledBases[i], filled[i]);
    }
  }

  return acc;
}
