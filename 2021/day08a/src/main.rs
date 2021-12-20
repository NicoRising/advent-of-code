use std::fs::File;
use std::io::Read;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut contents = String::new();
    file.read_to_string(&mut contents).unwrap();
    let mut unique: u32 = 0;
    for line in contents.lines() {
        for digit in line[(line.find(|chr| chr == '|' ).unwrap() + 1)..].split_whitespace() {
            unique += match digit.len() { 2 | 3 | 4 | 7 => 1, _ => 0 }
        }
    }
    println!("{}", unique);
}