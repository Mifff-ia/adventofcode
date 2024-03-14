use std::io;
mod day1;
mod day10;
mod day11;
mod day12;
mod day2;
mod day3;
mod day4;
mod day5;
mod day6;
mod day7;
mod day8;
mod day9;

type AnswerFunc = for<'a> fn(&'a str) -> i64;
type Day = (AnswerFunc, AnswerFunc);

const DAYS: [Day; 12] = [
    (day1::answer1, day1::answer2),
    (day2::answer1, day2::answer2),
    (day3::answer1, day3::answer2),
    (day4::answer1, day4::answer2),
    (day5::answer1, day5::answer2),
    (day6::answer1, day6::answer2),
    (day7::answer1, day7::answer2),
    (day8::answer1, day8::answer2),
    (day9::answer1, day9::answer2),
    (day10::answer1, day10::answer2),
    (day11::answer1, day11::answer2),
    (day12::answer1, day12::answer2),
];
const INPUT_PATH: &'static str = "../input/";

fn main() -> Result<(), Box<dyn std::error::Error>> {
    print_day(12)?;
    Ok(())
}

#[allow(dead_code)]
fn print_all_days() -> io::Result<()> {
    for idx in 0..DAYS.len() {
        print_day(idx + 1)?
    }
    Ok(())
}

fn print_day(day: usize) -> io::Result<()> {
    let data = std::fs::read_to_string(format!("{INPUT_PATH}day{day}.input"))?;
    let (answer1, answer2) = DAYS[day - 1];
    println!("Day {day}:");
    println!("Answer 1: {}", answer1(&data));
    println!("Answer 2: {}", answer2(&data));
    Ok(())
}
