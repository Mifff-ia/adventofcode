pub fn answer1(input: &str) -> i64 {
    let data = parse(input);
    data.into_iter()
        .map(|reading| {
            reading[reading.len() - 1] + descend_forward(&reading).unwrap().iter().sum::<i64>()
        })
        .sum()
}

pub fn answer2(input: &str) -> i64 {
    let data = parse(input);
    data.into_iter()
        .map(|reading| reading[0] + descend_backward(&reading).unwrap().iter().sum::<i64>())
        .sum()
}

fn descend_forward(slice: &[i64]) -> Option<Vec<i64>> {
    if slice.len() == 1 {
        (slice[0] == 0).then_some(vec![])
    } else {
        let next = slice.windows(2).map(|x| x[1] - x[0]).collect::<Vec<_>>();
        descend_forward(&next).map(|mut x| {
            x.push(next[next.len() - 1]);
            x
        })
    }
}

fn descend_backward(slice: &[i64]) -> Option<Vec<i64>> {
    if slice.len() == 1 {
        (slice[0] == 0).then_some(vec![])
    } else {
        let next = slice.windows(2).map(|x| x[0] - x[1]).collect::<Vec<_>>();
        descend_backward(&next).map(|mut x| {
            x.push(next[0]);
            x
        })
    }
}

fn parse(input: &str) -> Vec<Vec<i64>> {
    input
        .lines()
        .map(|x| x.split_whitespace().map(|x| x.parse().unwrap()).collect())
        .collect()
}
