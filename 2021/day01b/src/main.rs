use std::fs::File;
use std::io::Read;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut input = String::new();

    file.read_to_string(&mut input).unwrap();

    let depths: Vec<u32> = input.lines().map(
        |line| line.parse::<u32>().unwrap()
    ).collect();

    let mut increases = 0;

    for index in 0..(depths.len() - 3) {
        if depths[index] < depths[index + 3] {
            increases += 1;
        }
    }

    println!("{}", increases);
}
