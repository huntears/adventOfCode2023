#!/usr/bin/env python3

import sys
import argparse
import itertools

class Card:
    def __init__(self, line: str) -> None:
        workable_part = line.split(": ")[1]
        splitted = workable_part.split(" | ")
        self.wins = list(map(int, splitted[0].split()))
        self.haves = list(map(int, splitted[1].split()))
        self.matching = None
        self.score = None

    def get_matching(self) -> int:
        if self.matching is None:
            self.matching = len(list(filter(lambda x: x[0] == x[1], itertools.product(self.wins, self.haves))))
        return self.matching

    def get_score(self) -> int:
        if self.score is None:
            matching = self.get_matching()
            self.score = 2 ** (matching - 1) if matching > 0 else 0
        return self.score

def do_part2(cards: list[Card]) -> int:
    return 0 if len(cards) == 0 else 1 + sum(map(lambda x: do_part2(cards[x:]), range(1, cards[0].get_matching() + 1)))

def part2() -> None:
    with open("input.txt", "r") as f:
        cards = [Card(i) for i in f.readlines()]
        print(sum([do_part2(cards[i:]) for i in range(len(cards))]))

def part1() -> None:
    with open("input.txt", "r") as f:
        cards = [Card(i) for i in f.readlines()]
        print(sum(map(lambda x: x.get_score(), cards)))

def main() -> int:
    parser = argparse.ArgumentParser(prog="Day04")
    parser.add_argument("-2", "--part2", action="store_true")
    args = parser.parse_args()
    if (args.part2):
        part2()
    else:
        part1()
    return 0

if __name__ == "__main__":
    sys.exit(main())
