use std::{collections::HashMap, str::FromStr};

pub fn answer1(input: &str) -> i64 {
    let data: Input = input.parse().unwrap();
    let mut loc = "AAA".to_owned();
    for (idx, turn) in data.route.chars().into_iter().cycle().enumerate() {
        let node = &data.nodes[&loc];
        loc = match turn {
            'L' => node.left.clone(),
            'R' => node.right.clone(),
            _ => unreachable!(),
        };
        if loc == "ZZZ" {
            return idx as i64 + 1;
        }
    }
    unreachable!()
}

fn gcd(a: i64, b: i64) -> i64 {
    let mut a = a;
    let mut b = b;
    while b != 0 {
        (a, b) = (b, a % b)
    }
    a
}

pub fn answer2(input: &str) -> i64 {
    let data: Input = input.parse().unwrap();
    let durations = data
        .starts
        .iter()
        .map(|start| {
            let mut loc = start.to_owned();
            for (idx, turn) in data.route.chars().into_iter().cycle().enumerate() {
                let node = &data.nodes[&loc];
                loc = match turn {
                    'L' => node.left.clone(),
                    'R' => node.right.clone(),
                    _ => unreachable!(),
                };
                if loc.ends_with("Z") {
                    return idx as i64 + 1;
                }
            }
            unreachable!()
        })
        .collect::<Vec<_>>();
    durations
        .into_iter()
        .fold(1, |acc, num| (acc * num) / gcd(acc, num))
}

#[derive(Debug, Clone)]
struct Node {
    left: String,
    right: String,
}

#[derive(Debug, PartialEq, Eq)]
struct ParseNodeError(String);

impl FromStr for Node {
    type Err = ParseNodeError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let (left, right) = s
            .trim_start_matches("(")
            .trim_end_matches(")")
            .split_once(", ")
            .ok_or(ParseNodeError(s.to_owned()))?;
        Ok(Node {
            left: left.to_owned(),
            right: right.to_owned(),
        })
    }
}

#[derive(Debug)]
struct Input {
    route: String,
    starts: Vec<String>,
    nodes: HashMap<String, Node>,
}

#[derive(Debug, PartialEq, Eq)]
struct ParseInputError(String);

impl FromStr for Input {
    type Err = ParseInputError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let (route, nodes) = s.split_once("\n\n").ok_or(ParseInputError(s.to_owned()))?;
        let nodes = nodes.lines().map(|x| {
            let (name, data) = x.split_once(" = ").unwrap();
            (name.to_owned(), data.parse::<Node>().unwrap())
        });
        Ok(Input {
            route: route.to_owned(),
            starts: nodes
                .clone()
                .filter_map(|(name, _)| name.ends_with("A").then_some(name))
                .collect(),
            nodes: nodes.collect(),
        })
    }
}
