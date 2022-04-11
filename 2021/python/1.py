#!/usr/bin/env python3

import sys

data = []
for line in sys.stdin:
    data.append(int(line.rstrip()))

def answer1(data):
    prev = sys.maxsize
    count = 0
    for i in data:
        if prev < i:
            count += 1
        prev = i
    return count

def answer2(data):
    prev1, prev2 = (data[0], data[1])
    prevsum = sys.maxsize
    count = 0
    for i in data[2:]:
        sum = prev1 + prev2 + i
        if prevsum < sum:
            count += 1
        prevsum = sum
        prev1 = prev2
        prev2 = i
    return count

print(answer1(data), answer2(data))
