#!/usr/bin/env python3

import sys

def parse():
    acc = []
    for line in sys.stdin:
        [direction, magnitude] = line.split()
        acc.append((direction, int(magnitude)))
    return acc

data = parse()

def answer1(data):
    position, depth = (0, 0)
    for (direction, magnitude) in data:
        if direction == 'forward':
            position += magnitude
        elif direction == 'up':
            depth -= magnitude
        else:
            depth += magnitude
    return position * depth

def answer2(data):
    aim, position, depth = (0, 0, 0)
    for (direction, magnitude) in data:
        if direction == 'forward':
            position += magnitude
            depth += magnitude * aim
        elif direction == 'down':
            aim += magnitude
        elif direction == 'up':
            aim -= magnitude
    return position * depth

print(answer1(data), answer2(data))
