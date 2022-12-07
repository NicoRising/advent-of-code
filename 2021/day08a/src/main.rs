use std::fs::File;
use std::io::Read;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut input = String::new();

    file.read_to_string(&mut input).unwrap();

    let mut unique: u32 = 0;

    for line in input.lines() {
        let output = &line[(line.find(|chr| chr == '|').unwrap() + 2)..];

        for digit in output.split_whitespace() {
            unique += match digit.len() {
                2 | 3 | 4 | 7 => 1,
                _ => 0
            }
        }
    }

    println!("{}", unique);
}
