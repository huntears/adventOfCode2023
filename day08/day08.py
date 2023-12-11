#!/usr/bin/env python3

import sys
import argparse
from functools import reduce
import math

def solve(current_node: str, instructions: str, nodes: dict[str, list[str]]) -> int:
    number_instructions = 0
    while current_node[-1] != "Z":
        current_node = nodes[current_node][0 if instructions[number_instructions % (len(instructions) - 1)] == "L" else 1]
        number_instructions += 1
    return number_instructions

def part2() -> None:
    with open("input.txt", "r") as f:
        with open("input.txt", "r") as f:
            lines = f.readlines()
            instructions = lines[0]
            nodes = dict()
            for i in lines[2:]:
                nodes[i[0:3]] = [i[7:10], i[12:15]]
            current_nodes = list(filter(lambda x: x[-1] == "A", nodes.keys()))
            results = [solve(i, instructions, nodes) for i in current_nodes]
            print(results)
            print(math.lcm(*results))

def part1() -> None:
    with open("input.txt", "r") as f:
        lines = f.readlines()
        instructions = lines[0]
        nodes = dict()
        for i in lines[2:]:
            nodes[i[0:3]] = [i[7:10], i[12:15]]
        print(solve("AAA", instructions, nodes))

def main() -> int:
    parser = argparse.ArgumentParser(prog="Day08")
    parser.add_argument("-2", "--part2", action="store_true")
    args = parser.parse_args()
    if (args.part2):
        part2()
    else:
        part1()
    return 0

if __name__ == "__main__":
    sys.exit(main())
