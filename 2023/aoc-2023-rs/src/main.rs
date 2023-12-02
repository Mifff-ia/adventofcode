use std::io;
mod day1;

type AnswerFunc = for<'a> fn(&'a str) -> i64;
type Day = (AnswerFunc, AnswerFunc);

const DAYS: [Day; 1] = [(day1::answer1, day1::answer2)];
const INPUT_PATH: &'static str = "../input/";

fn main() -> Result<(), Box<dyn std::error::Error>> {
    print_all_days(&DAYS)?;
    Ok(())
}

fn print_all_days(days: &[Day]) -> io::Result<()> {
    for (idx, day) in days.iter().enumerate() {
        print_day(idx + 1, day)?
    }
    Ok(())
}

fn print_day(day: usize, (answer1, answer2): &(AnswerFunc, AnswerFunc)) -> io::Result<()> {
    let data = std::fs::read_to_string(format!("{INPUT_PATH}day{day}.input"))?;
    println!("Day {day}:");
    println!("Answer 1: {}", answer1(&data));
    println!("Answer 2: {}", answer2(&data));
    Ok(())
}
