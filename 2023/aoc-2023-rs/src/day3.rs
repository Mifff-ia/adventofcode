use regex;

pub fn answer1(input: &str) -> i64 {
    let specials = specials(input);
    let nums = nums(input);
    nums.iter()
        .enumerate()
        .map(|(idx, line)| {
            line.iter()
                .filter(|num| {
                    let relevant_indices =
                        if idx == 0 { 0 } else { idx - 1 }..=(idx + 1).clamp(0, specials.len() - 1);

                    specials[relevant_indices]
                        .iter()
                        .flatten()
                        .any(|x| (num.start() as i64 - 1) <= *x as i64 && num.end() + 1 > *x)
                })
                .map(|num| num.as_str().parse::<i64>().unwrap())
                .sum::<i64>()
        })
        .sum()
}

pub fn answer2(input: &str) -> i64 {
    let specials = asterisks(input);
    let nums = nums(input);
    specials
        .iter()
        .enumerate()
        .map(|(idx, line)| {
            line.iter()
                .map(|special| {
                    let relevant_indices =
                        if idx == 0 { 0 } else { idx - 1 }..=(idx + 1).clamp(0, specials.len() - 1);

                    let near_numbers = nums[relevant_indices]
                        .iter()
                        .flat_map(|line| {
                            line.iter().filter(|num| {
                                (num.start() as i64 - 1) <= *special as i64
                                    && num.end() + 1 > *special
                            })
                        })
                        .collect::<Vec<_>>();

                    if near_numbers.len() == 2 {
                        near_numbers
                            .iter()
                            .map(|num| num.as_str().parse::<i64>().unwrap())
                            .product()
                    } else {
                        0
                    }
                })
                .sum::<i64>()
        })
        .sum()
}

fn nums(input: &str) -> Vec<Vec<regex::Match>> {
    let re = regex::Regex::new(r"\d+").unwrap();
    input.lines().map(|x| re.find_iter(x).collect()).collect()
}

fn asterisks(input: &str) -> Vec<Vec<usize>> {
    let re = regex::Regex::new(r"[*]").unwrap();
    input
        .lines()
        .map(|x| re.find_iter(x).map(|y| y.start()).collect())
        .collect()
}

fn specials(input: &str) -> Vec<Vec<usize>> {
    let re = regex::Regex::new(r"[/@*$=&#\-+%]").unwrap();
    input
        .lines()
        .map(|x| re.find_iter(x).map(|y| y.start()).collect())
        .collect()
}
