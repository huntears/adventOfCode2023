#!/usr/bin/env python3

from dataclasses import dataclass
import sys
import argparse

@dataclass
class Pick:
    red: int = 0
    blue: int = 0
    green: int = 0

    def __init__(self, line: str):
        for i in line.split(", "):
            tmp = i.split()
            if tmp[1] == "blue":
                self.blue = int(tmp[0])
            elif tmp[1] == "red":
                self.red = int(tmp[0])
            else:
                self.green = int(tmp[0])

@dataclass
class Game:
    id: int
    picks: list[Pick]

    def __init__(self, line: str):
        self.id = int(line.split(":")[0].split()[1])
        self.picks = [Pick(i) for i in line.split(": ")[1].split("; ")]

    def validates_part1(self) -> int:
        return self.id if all(map(lambda x: x.red <= 12 and x.green <= 13 and x.blue <= 14, self.picks)) else 0

    def get_minimum_product_pick(self) -> int:
        min_blue = self.picks[0].blue
        min_red = self.picks[0].red
        min_green = self.picks[0].green
        for i in self.picks[1:]:
            min_blue = max(i.blue, min_blue)
            min_red = max(i.red, min_red)
            min_green = max(i.green, min_green)
        return min_green * min_blue * min_red

def part2() -> None:
    with open("input.txt", "r") as f:
        print(f"Result: {sum(map(lambda x: x.get_minimum_product_pick(), [Game(i) for i in f.readlines()]))}")

def part1() -> None:
    with open("input.txt", "r") as f:
        print(f"Result: {sum(map(lambda x: x.validates_part1(), [Game(i) for i in f.readlines()]))}")

def main() -> int:
    parser = argparse.ArgumentParser(prog="Day02")
    parser.add_argument("-2", "--part2", action="store_true")
    args = parser.parse_args()
    if (args.part2):
        part2()
    else:
        part1()
    return 0

if __name__ == "__main__":
    sys.exit(main())
