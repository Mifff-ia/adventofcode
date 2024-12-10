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
  for (int i = 0; i < all.length && left <= right;) {
    if (isAtLeft) {
      print("$i left $left offset $offset ${filled[left]}");
      acc += left * sumRange(offset, filled[left]);
      print("$left ${sumRange(offset, filled[left])}");
      isAtLeft = !isAtLeft;
      offset += filled[left];
      all[i] = 0;
      filled[left] = 0;
      left++;
      i++;
    } else {
      if (all[i] > filled[right]) {
        print("$i right $right offset $offset filled ${filled[right]}");
        acc += right * sumRange(offset, filled[right]);
        print("$right ${sumRange(offset, filled[right])}");
        offset += filled[right];
        all[i] -= filled[right];
        filled[right] = 0;
        right--;
      } else if (all[i] == filled[right]) {
        print("$i right $right offset $offset both ${filled[right]}");
        acc += right * sumRange(offset, filled[right]);
        print("$right ${sumRange(offset, filled[right])}");
        offset += filled[right];
        isAtLeft = !isAtLeft;
        filled[right] = 0;
        all[i] = 0;
        right--;
        i++;
      } else {
        print("$i right $right offset $offset all ${all[i]}");
        acc += right * sumRange(offset, all[i]);
        print("$right ${sumRange(offset, all[right])}");
        offset += all[i];
        filled[right] -= all[i];
        all[i] = 0;
        isAtLeft = !isAtLeft;
        i++;
      }
    }
  }
  print("$filled, $acc");
  return acc;
}

int answer2(String input) {
  return 0;
}
