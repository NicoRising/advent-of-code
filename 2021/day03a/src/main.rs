use std::fs::File;
use std::io::Read;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut input = String::new();

    file.read_to_string(&mut input).unwrap();

    let numbers: Vec<Vec<bool>> = input.lines().map(|line| {
        line.chars().map(|bit| bit == '1').collect()
    }).collect();

    let binary_length = numbers.first().unwrap().len() as u32;
    let mut gamma = 0;
    let mut epsilon = 0;

    for bit in 0..(binary_length as usize) {
        let ones = numbers.iter().filter(|number| number[bit]).count();

        if ones > numbers.len() / 2 {
            gamma += 2_u32.pow(binary_length - bit as u32 - 1);
        } else {
            epsilon += 2_u32.pow(binary_length - bit as u32 - 1);
        }
    }

    println!("{}", gamma * epsilon)
}
