pub fn answer1(input: &str) -> i64 {
    let data = parse(input);
    data.iter()
        .map(|(reel, nums)| ways(reel, nums))
        .sum::<usize>() as i64
}

pub fn answer2(input: &str) -> i64 {
    0
}

fn parse(input: &str) -> Vec<(Vec<char>, Vec<usize>)> {
    input
        .lines()
        .map(|x| {
            let (reel, nums) = x.split_once(" ").unwrap();
            (
                reel.chars().collect(),
                nums.split(",").map(|x| x.parse().unwrap()).collect(),
            )
        })
        .collect()
}

fn ways(reel: &[char], nums: &[usize]) -> usize {
    if nums.is_empty() {
        1
    } else if reel.is_empty() {
        0
    } else if reel[0] == '.' {
        ways(&reel[1..], nums)
    } else {
        (if find(reel, nums[0]) {
            if nums[0] == reel.len() {
                (nums.len() == 1).into()
            } else {
                ways(&reel[nums[0] + 1..reel.len()], &nums[1..])
            }
        } else {
            0
        }) + if reel[0] == '?' {
            ways(&reel[1..], nums)
        } else {
            0
        }
    }
}

fn find(reel: &[char], num: usize) -> bool {
    let ans = reel
        .iter()
        .take(num)
        .filter(|x| **x == '#' || **x == '?')
        .count()
        == num
        && (num == reel.len() || reel[num] != '#');
    ans
}
