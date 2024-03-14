use std::collections::HashMap;
use std::str::FromStr;

pub fn answer1(input: &str) -> i64 {
    let mut data = parse(input);
    data.sort_by_key(|(hand, _)| (*hand).clone());
    data.into_iter()
        .enumerate()
        .fold(0, |acc, (idx, (_, bid))| acc + (idx as i64 + 1) * bid)
}

pub fn answer2(input: &str) -> i64 {
    let mut data = parse2(input);
    data.sort_by_key(|(hand, _)| (*hand).clone());
    data.into_iter()
        .enumerate()
        .fold(0, |acc, (idx, (_, bid))| acc + (idx as i64 + 1) * bid)
}

fn parse(input: &str) -> Vec<(Hand, i64)> {
    input
        .lines()
        .map(|x| {
            let (hand, bid) = x.split_once(" ").unwrap();
            (Hand::new(hand), bid.parse().unwrap())
        })
        .collect()
}

fn parse2(input: &str) -> Vec<(JokerHand, i64)> {
    input
        .lines()
        .map(|x| {
            let (hand, bid) = x.split_once(" ").unwrap();
            (JokerHand::new(hand), bid.parse().unwrap())
        })
        .collect()
}

#[derive(Clone, Debug, PartialEq, PartialOrd, Eq, Ord)]
struct Hand {
    win: Type,
    order: Vec<i64>,
}

#[derive(Clone, Debug, PartialEq, PartialOrd, Eq, Ord)]
struct JokerHand {
    win: Type,
    order: Vec<i64>,
}

impl JokerHand {
    fn new(hand: &str) -> Self {
        Self {
            order: JokerHand::make_order(hand),
            win: Type::joker_parse(hand).unwrap(),
        }
    }

    fn make_order(hand: &str) -> Vec<i64> {
        let scores = HashMap::from([
            ('A', 12),
            ('K', 11),
            ('Q', 10),
            ('T', 09),
            ('9', 08),
            ('8', 07),
            ('7', 06),
            ('6', 05),
            ('5', 04),
            ('4', 03),
            ('3', 02),
            ('2', 01),
            ('J', 00),
        ]);
        hand.chars().map(|x| *scores.get(&x).unwrap()).collect()
    }
}

impl Hand {
    fn new(hand: &str) -> Self {
        Hand {
            order: Hand::make_order(hand),
            win: hand.parse().unwrap(),
        }
    }

    fn make_order(hand: &str) -> Vec<i64> {
        let scores = HashMap::from([
            ('A', 12),
            ('K', 11),
            ('Q', 10),
            ('J', 09),
            ('T', 08),
            ('9', 07),
            ('8', 06),
            ('7', 05),
            ('6', 04),
            ('5', 03),
            ('4', 02),
            ('3', 01),
            ('2', 00),
        ]);
        hand.chars().map(|x| *scores.get(&x).unwrap()).collect()
    }
}

#[derive(Clone, Debug, PartialEq, PartialOrd, Eq, Ord)]
enum Type {
    HighCard,
    OnePair,
    TwoPair,
    ThreeOfAKind,
    FullHouse,
    FourOfAKind,
    FiveOfAKind,
}

#[derive(Debug, PartialEq, Eq)]
struct ParseTypeError(char);

impl Type {
    fn joker_parse(s: &str) -> Result<Self, <Self as FromStr>::Err> {
        let char_array = s.chars().collect::<Vec<_>>();
        let mut unique = char_array.clone();
        unique.sort();
        unique.dedup();
        let most = unique
            .clone()
            .into_iter()
            .map(|x| s.matches(x).count())
            .enumerate()
            .filter(|(idx, _)| unique[*idx] != 'J')
            .max_by_key(|(_, count)| *count)
            .map(|(most, _)| unique[most])
            .unwrap_or('J');
        let ans = (&s).replace('J', &format!("{}", most)).parse();
        ans
    }
}

impl FromStr for Type {
    type Err = ParseTypeError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let char_array = s.chars().collect::<Vec<_>>();
        let mut unique = char_array.clone();
        unique.sort();
        unique.dedup();
        unique.iter().try_for_each(|x| {
            if !"1234567890AJQTK".contains(*x) {
                Err(ParseTypeError(*x))
            } else {
                Ok(())
            }
        })?;
        let counts = unique
            .clone()
            .into_iter()
            .map(|x| s.matches(x).count())
            .enumerate()
            .collect::<Vec<_>>();
        Ok(if unique.len() == 1 {
            Type::FiveOfAKind
        } else if unique.len() == 2 {
            // By the pigeon-hole principle, the least number of elements the biggest group
            // has can be only 3 or 4
            if counts.iter().find(|(_, x)| *x == 4).is_some() {
                Type::FourOfAKind
            } else {
                if counts.iter().find(|(_, x)| *x == 2).is_some() {
                    Type::FullHouse
                } else {
                    Type::ThreeOfAKind
                }
            }
        } else if unique.len() == 3 {
            if counts.iter().find(|(_, x)| (*x == 3)).is_some() {
                Type::ThreeOfAKind
            } else {
                let pair = counts
                    .iter()
                    .find_map(|(ind, x)| (*x == 2).then_some(ind))
                    .unwrap();
                if counts
                    .iter()
                    .find(|(ind, x)| *x == 2 && ind != pair)
                    .is_some()
                {
                    Type::TwoPair
                } else {
                    Type::OnePair
                }
            }
        } else if unique.len() == 4 {
            Type::OnePair
        } else {
            Type::HighCard
        })
    }
}
