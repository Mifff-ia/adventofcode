pub fn answer1(input: &str) -> i64 {
    num_wins(parse(input))
        .iter()
        .map(|winners| {
            if *winners == 0 {
                0
            } else {
                (2 as i64).pow(*winners as u32 - 1)
            }
        })
        .sum()
}

pub fn answer2(input: &str) -> i64 {
    let wins = num_wins(parse(input));
    let mut cards = vec![1; wins.len()];
    wins.iter().enumerate().for_each(|(idx, win)| {
        let num_cards = cards[idx].clone();
        cards[(idx + 1).clamp(0, wins.len())..(idx + 1 + *win as usize).clamp(0, wins.len())]
            .iter_mut()
            .for_each(|card| {
                *card += num_cards;
            });
    });
    cards.iter().sum()
}

fn num_wins(data: Vec<(Vec<i64>, Vec<i64>)>) -> Vec<i64> {
    data.iter()
        .map(|(nums, wins)| nums.iter().filter(|x| wins.contains(x)).count() as i64)
        .collect()
}

fn parse(input: &str) -> Vec<(Vec<i64>, Vec<i64>)> {
    input
        .lines()
        .map(|line| {
            let (_, card_num_removed) = line.split_once(":").unwrap();
            let (nums, wins) = card_num_removed.split_once("|").unwrap();
            let nums = nums
                .trim()
                .split_whitespace()
                .map(|x| x.parse().unwrap())
                .collect();
            let wins = wins
                .trim()
                .split_whitespace()
                .map(|x| x.parse().unwrap())
                .collect();
            (nums, wins)
        })
        .collect()
}
