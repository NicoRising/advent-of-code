use std::fs::File;
use std::io::Read;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut contents = String::new();
    file.read_to_string(&mut contents).unwrap();
    let depths: Vec<u32> = contents.split("\n").map(|line| line.parse::<u32>().unwrap()).collect();
    let mut increases = 0;
    for index in 0..(depths.len() - 1) {
        if depths[index] < depths[index + 1] {
            increases += 1;
        }
    }
    println!("{}", increases);
}