#!/usr/bin/env python3

from dataclasses import dataclass
import sys
import argparse

cache = {}
cache_hit = 0
cache_miss = 0

@dataclass
class Series:
    springs: str
    results: list[int]
    total_faulty: int
    known_faulty: int

    def __init__(self, line: str, part2 = False) -> None:
        tmp = line.split()
        if not part2:
            self.springs = tmp[0]
            self.results = list(map(int, tmp[1].split(",")))
        else:
            self.springs = "?".join([tmp[0] for _ in range(5)])
            self.results = list(map(int, tmp[1].split(","))) * 5
        self.total_faulty = sum(self.results)
        self.known_faulty = self.springs.count("#")

    def __get_recur_solutions(self, springs: str, results: list[int]):
        global cache
        global cache_miss
        global cache_hit

        if springs + str(results) in cache.keys():
            cache_hit += 1
            return cache[springs + str(results)]
        cache_miss += 1

        if not results:
            return '#' not in springs

        result = 0
        for position in range(len(springs) - sum(results) + len(results)):
            possible = '.' * position + '#' * results[0] + '.'
            for spring, possible_spring in zip(springs, possible):
                if spring != possible_spring and spring != '?':
                    break
            else:
                result += self.__get_recur_solutions(springs[len(possible):], results[1:])

        cache[springs + str(results)] = result
        return result
        
    def get_number_of_solutions(self) -> int:
        result = self.__get_recur_solutions(self.springs, self.results)
        return result

def part2() -> None:
    with open("input.txt", "r") as f:
        print(f"Result: {sum(map(lambda x: x.get_number_of_solutions(), [Series(i, True) for i in f.readlines()]))}")
        print(f"Cache size: {len(cache.keys())}")
        print(f"Cache miss: {cache_miss}")
        print(f"Cache hit: {cache_hit}")

def part1() -> None:
    with open("input.txt", "r") as f:
        print(f"Result: {sum(map(lambda x: x.get_number_of_solutions(), [Series(i) for i in f.readlines()]))}")
        print(f"Cache size: {len(cache.keys())}")
        print(f"Cache miss: {cache_miss}")
        print(f"Cache hit: {cache_hit}")

def main() -> int:
    parser = argparse.ArgumentParser(prog="Day12")
    parser.add_argument("-2", "--part2", action="store_true")
    args = parser.parse_args()
    if (args.part2):
        part2()
    else:
        part1()
    return 0

if __name__ == "__main__":
    sys.exit(main())
