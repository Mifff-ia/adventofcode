#!/usr/bin/env python3

import sys
import copy

def parse():
    acc = ''.join(sys.stdin).rstrip('\n').split('\n\n')
    numbers = [int(x) for x in acc[0].strip().split(',')]
    boards = list(map(lambda board: list(map(lambda x: [int(i) for i in x.strip().split()], board.split('\n'))), acc[1:]))
    return numbers, boards

numbers, boards = parse()

def did_board_win(marked_board):
    def transpose(xs):
        acc = []
        for i in range(len(xs[0])):
            row =[]
            for item in xs:
                row.append(item[i])
            acc.append(row)
        return acc
    return any(map(all, transpose(marked_board))) or any(map(all, marked_board))

def board_score(board, marked_board):
    acc = 0
    for j, row in enumerate(board):
        for i, elem in enumerate(row):
            if not marked_board[j][i]:
                acc += elem
    return acc

def answer1(numbers, boards):
    marked_boards = []
    for x in range(len(boards)):
        marked_boards.append(list([False, False, False, False, False] for i in range(5)))

    for number in numbers:
        for k, board in enumerate(boards):
            for j, row in enumerate(board):
                for i, elem in enumerate(row):
                    if number == elem:
                        marked_boards[k][j][i] = True
            if did_board_win(marked_boards[k]):
                return number * board_score(board, marked_boards[k])

def answer2(numbers, boards):
    marked_boards = []
    for x in range(len(boards)):
        marked_boards.append(list([False, False, False, False, False] for i in range(5)))

    for number in numbers:
        b = []
        mb = []
        for k, board in enumerate(boards):
            for j, row in enumerate(board):
                for i, elem in enumerate(row):
                    if number == elem:
                        marked_boards[k][j][i] = True

            if not did_board_win(marked_boards[k]):
                b.append(board)
                mb.append(marked_boards[k])

            if len(boards) == 1 and did_board_win(marked_boards[0]):
                return number * board_score(board, marked_boards[0])
        boards = b
        marked_boards = mb

print(answer1(numbers, boards), answer2(numbers, boards))
