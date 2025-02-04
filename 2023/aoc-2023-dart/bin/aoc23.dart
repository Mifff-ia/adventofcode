import 'dart:io' as io;
import 'package:aoc23/day1.dart' as day1;

var days = [(answer1: day1.answer1, answer2: day1.answer2)];

void log(Object object) {
  io.stderr.write("$object\n");
}

void printUsage() {
  log("usage: aoc23 <day number> [<input file>]");
}

void main(List<String> arguments) async {
  if (arguments.isEmpty) {
    printUsage();
    return;
  }

  final day = int.parse(arguments[0]);
  if (day < 1 || day > 25) {
    log("Day number should be between 1 and 25.");
    printUsage();
    return;
  }

  var inputFileName = arguments.elementAtOrNull(1);
  if (inputFileName == null) {
    inputFileName = "../input/day$day.input";
    log("Input file not specified, using default input file $inputFileName");
  }
  await calculateDay(day, inputFileName);
}

Future<void> calculateDay(int day, String inputFileName) async {
  assert(days.length >= day && day >= 1);
  return io.File(inputFileName).readAsString().then((input) {
    print("Day $day");
    print("Answer 1: ${days[day - 1].answer1(input)}");
    print("Answer 2: ${days[day - 1].answer2(input)}");
  });
}
