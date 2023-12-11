#!/usr/bin/env python3

import sys
import argparse

def gen_line_diff(line: list[int]) -> list[int]:
    result = []
    for i in range(len(line) - 1):
        result.append(line[i + 1] - line[i])
    return result

def get_next_2(line: list[int]) -> list[int]:
    if all(map(lambda x: x == 0, line)):
        return [0] + line
    return [line[0] - get_next_2(gen_line_diff(line))[0]] + line

def part2() -> None:
    with open("input.txt", "r") as f:
        numbers = [list(map(int, i.split())) for i in f.readlines()]
        result = sum([get_next_2(i)[0] for i in numbers])
        print(result)

def get_next(line: list[int]) -> list[int]:
    if all(map(lambda x: x == 0, line)):
        return line + [0]
    return line + [get_next(gen_line_diff(line))[-1] + line[-1]]
    
def part1() -> None:
    with open("input.txt", "r") as f:
        numbers = [list(map(int, i.split())) for i in f.readlines()]
        result = sum([get_next(i)[-1] for i in numbers])
        print(result)

def main() -> int:
    parser = argparse.ArgumentParser(prog="Day09")
    parser.add_argument("-2", "--part2", action="store_true")
    args = parser.parse_args()
    if (args.part2):
        part2()
    else:
        part1()
    return 0

if __name__ == "__main__":
    sys.exit(main())
