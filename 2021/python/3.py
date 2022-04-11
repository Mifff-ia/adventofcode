#!/usr/bin/env python3

import sys

def parse():
    acc = []
    for line in sys.stdin:
        length = len(line)
        acc.append(int(line, 2))
    return (acc, length)

data, length = parse()

def answer1(data, length):
    mask = 1 << (length - 2)
    gamma = 0
    epsilon = 0

    while mask != 0:
        gamma <<= 1
        epsilon <<= 1
        ones = sum(map(lambda x: x & mask != 0, data))
        if ones > len(data)/2:
            gamma |= 1
        else:
            epsilon |= 1
        mask >>= 1

    return gamma * epsilon

def answer2(data, length):
    mask = 1 << (length - 2)

    def f(data, predicate, mask):
        while len(data) > 1:
            ones = sum(map(lambda x: x & mask != 0, data))
            value = predicate(ones, len(data) - ones)
            data = list(filter(lambda x: (x & mask != 0) == value, data))
            mask >>= 1
        return data[0]

    oxygen = f(data, lambda ones, zeros: ones >= zeros, mask)
    co2 = f(data, lambda ones, zeros: ones < zeros, mask)

    return co2 * oxygen

print(answer1(data, length), answer2(data, length))
