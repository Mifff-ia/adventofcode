use once_cell::sync::Lazy;
use std::collections::HashMap;

static COLOR_MAP: Lazy<HashMap<&str, usize>> =
    Lazy::new(|| HashMap::from([("red", 0), ("green", 1), ("blue", 2)]));

pub fn answer1(input: &str) -> i64 {
    let data = parse(input);
    let mut out = 0;
    'outer: for (idx, game) in data.iter().enumerate() {
        for show in game {
            let (r, g, b) = show;
            if *r > 12 || *g > 13 || *b > 14 {
                continue 'outer;
            }
        }
        out += idx + 1;
    }
    out as i64
}

pub fn answer2(input: &str) -> i64 {
    let data = parse(input);
    data.iter()
        .map(|x| {
            let (r, g, b) = x
                .iter()
                .fold((0, 0, 0), |(acc_r, acc_g, acc_b), (r, g, b)| {
                    (acc_r.max(*r), acc_g.max(*g), acc_b.max(*b))
                });
            r * g * b
        })
        .sum()
}

fn parse(input: &str) -> Vec<Vec<(i64, i64, i64)>> {
    input.lines().map(line_parse).collect()
}

fn line_parse(line: &str) -> Vec<(i64, i64, i64)> {
    line.split(":")
        .last()
        .unwrap()
        .trim()
        .split(";")
        .map(show_parse)
        .collect::<Vec<(i64, i64, i64)>>()
}

fn show_parse(show: &str) -> (i64, i64, i64) {
    let mut out = vec![0; 3];
    show.trim().split(",").map(|x| x.trim()).for_each(|i| {
        let [num, color] = i.split(" ").collect::<Vec<_>>()[..] else { unreachable!() };
        out[COLOR_MAP[color]] = num.parse().unwrap();
    });
    (out[0], out[1], out[2])
}
