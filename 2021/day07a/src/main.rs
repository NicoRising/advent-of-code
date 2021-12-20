use std::fs::File;
use std::io::Read;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut contents = String::new();
    file.read_to_string(&mut contents).unwrap();
    let mut crabs: Vec<u32> = contents.split(',').map(|pos| pos.parse::<u32>().unwrap()).collect();
    crabs.sort();
    let target = crabs[crabs.len() / 2];
    let mut fuel: u32 = 0;
    for crab in crabs {
        fuel += if crab > target { crab - target } else { target - crab };
    }
    println!("{}", fuel);
}