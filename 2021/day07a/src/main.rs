use std::fs::File;
use std::io::Read;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut input = String::new();

    file.read_to_string(&mut input).unwrap();
    input.pop(); // Remove the newline

    let mut crabs: Vec<u32> = input.split(',').map(
        |pos| pos.parse::<u32>().unwrap()
    ).collect();

    crabs.sort();

    let target = crabs[crabs.len() / 2];

    let fuel: u32 = crabs.iter().map(
        |crab| crab.abs_diff(target)
    ).sum();

    println!("{}", fuel);
}
