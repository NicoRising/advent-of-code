use std::fs::File;
use std::io::Read;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut contents = String::new();
    file.read_to_string(&mut contents).unwrap();
    let commands: Vec<(char, u32)> = contents.split("\n").map(|line| {
        let mut chars = line.chars();
        (chars.next().unwrap(), chars.last().unwrap().to_digit(10).unwrap())
    }).collect();
    let mut hor = 0;
    let mut depth = 0;
    for (command, value) in commands.iter() {
        if *command == 'f' {
            hor += value;
        } else if *command == 'd' {
            depth += value;
        } else if *command == 'u' {
            depth -= value;
        }
    }
    println!("{}", hor * depth);
}