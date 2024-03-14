pub fn answer1(input: &str) -> i64 {
    parse(input)
        .into_iter()
        .map(|(time, distance)| binary_search(time, distance))
        .product()
}

pub fn answer2(input: &str) -> i64 {
    let (time, distance) = parse2(input);
    binary_search(time, distance)
}

fn binary_search(time: i64, distance: i64) -> i64 {
    let mut start = 0;
    let mut end = time / 2;
    while start != end {
        let mid = (start + end) / 2;
        if mid * (time - mid) <= distance {
            start = mid + 1;
        } else {
            end = mid;
        }
    }
    time + 1 - start * 2
}

fn parse2(input: &str) -> (i64, i64) {
    let mut lines = input.lines();
    let line_parse = |line: &str| -> i64 {
        let (_, nums) = line.split_once(":").unwrap();
        nums.trim()
            .split_whitespace()
            .collect::<Vec<_>>()
            .join("")
            .parse::<i64>()
            .unwrap()
    };
    (
        line_parse(lines.next().unwrap()),
        line_parse(lines.next().unwrap()),
    )
}

fn parse(input: &str) -> Vec<(i64, i64)> {
    let mut lines = input.lines();
    let line_parse = |line: &str| -> Vec<i64> {
        let (_, nums) = line.split_once(":").unwrap();
        nums.trim()
            .split_whitespace()
            .map(|x| x.parse::<i64>().unwrap())
            .collect()
    };
    line_parse(lines.next().unwrap())
        .into_iter()
        .zip(line_parse(lines.next().unwrap()).into_iter())
        .collect()
}
