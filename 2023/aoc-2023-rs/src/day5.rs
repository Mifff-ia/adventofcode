use rayon::prelude::*;
use std::ops::Range;

#[derive(Debug)]
struct LinearRangeMap {
    keys: Vec<Range<i64>>,
    values: Vec<i64>,
}

impl LinearRangeMap {
    pub fn get(&self, key: i64) -> Option<i64> {
        for (idx, i) in self.keys.iter().enumerate() {
            if i.contains(&key) {
                return Some(self.values[idx] + (key - i.start));
            }
        }
        None
    }

    pub fn from_assoc(vals: Vec<(Range<i64>, i64)>) -> Self {
        let (keys, values): (Vec<_>, Vec<_>) = vals.into_iter().unzip();
        Self { keys, values }
    }
}

pub fn answer1(input: &str) -> i64 {
    let mut components = input.split("\n\n");
    let seeds = parse_seeds(components.next().unwrap());
    let maps = components.map(parse_linear_range_map).collect::<Vec<_>>();
    seeds
        .iter()
        .map(|seed| {
            maps.iter()
                .fold(*seed, |acc, item| item.get(acc).unwrap_or(acc))
        })
        .min()
        .unwrap()
}

pub fn answer2(input: &str) -> i64 {
    let mut components = input.split("\n\n");
    let seed_ranges = parse_seeds2(components.next().unwrap());
    let maps = components.map(parse_linear_range_map).collect::<Vec<_>>();
    seed_ranges
        .iter()
        .map(|seed_range| {
            seed_range
                .clone()
                .into_par_iter()
                .map(|seed| {
                    maps.iter()
                        .fold(seed, |acc, item| item.get(acc).unwrap_or(acc))
                })
                .min()
                .unwrap()
        })
        .min()
        .unwrap()
}

fn parse_seeds(input: &str) -> Vec<i64> {
    input
        .split_whitespace()
        .skip(1)
        .map(|x| x.parse().unwrap())
        .collect()
}

fn parse_seeds2(input: &str) -> Vec<Range<i64>> {
    let nums = parse_seeds(input);
    nums.iter()
        .step_by(2)
        .zip(nums.iter().skip(1).step_by(2))
        .map(|(x, range)| *x..*x + *range)
        .collect()
}

fn parse_linear_range_map(input: &str) -> LinearRangeMap {
    let assocs = input
        .lines()
        .skip(1)
        .map(|val| {
            let val = val
                .split_whitespace()
                .map(|x| x.parse().unwrap())
                .collect::<Vec<i64>>();

            let [dest, src, range] = *val.as_slice() else {unreachable!()};

            (
                Range {
                    start: src,
                    end: src + range,
                },
                dest,
            )
        })
        .collect();
    LinearRangeMap::from_assoc(assocs)
}
