use anyhow::Result;
use regex::Regex;
use std::collections::HashMap;
use std::str;

pub fn answer1(input: &str) -> i64 {
    let re = regex(r"\d");
    calc(input, re, &HashMap::new()).unwrap()
}

pub fn answer2(input: &str) -> i64 {
    let re = regex(r"\d|one|two|three|four|five|six|seven|eight|nine");
    calc(
        input,
        re,
        &HashMap::from([
            ("one", 1),
            ("two", 2),
            ("three", 3),
            ("four", 4),
            ("five", 5),
            ("six", 6),
            ("seven", 7),
            ("eight", 8),
            ("nine", 9),
        ]),
    )
    .unwrap()
}

fn regex(re: &str) -> Regex {
    // There are either two matches near the two ends of the line, or there is only one match
    Regex::new(&format!("^.*?(?:({0}).*({0})|({0})).*?$", re)).unwrap()
}

fn convert(hit: &regex::Match, converter: &HashMap<&str, i64>) -> i64 {
    let string = hit.as_str();
    if string.bytes().next().unwrap().is_ascii_digit() {
        string.parse().unwrap()
    } else {
        *converter.get(string).unwrap()
    }
}

fn calc(input: &str, re: Regex, converter: &HashMap<&str, i64>) -> Result<i64> {
    Ok(input
        .lines()
        .map(|lines| {
            let nums = re.captures(lines).unwrap();
            nums.get(3).map_or_else(
                || {
                    convert(&nums.get(1).unwrap(), converter) * 10
                        + convert(&nums.get(2).unwrap(), converter)
                },
                |x| {
                    let x = convert(&x, converter);
                    x * 10 + x
                },
            )
        })
        .sum())
}
