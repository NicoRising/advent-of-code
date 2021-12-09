use std::fs::File;
use std::io::Read;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut contents = String::new();
    file.read_to_string(&mut contents).unwrap();
    let numbers: Vec<Vec<bool>> = contents.split("\n").map(|line| {
        line.chars().map(|bit| {
            if bit == '1' {
                true
            } else {
                false
            }
        }).collect()
    }).collect();
    let mut gamma = String::new();
    let mut epsilon = String::new();
    for bit in 0..12 {
        let mut ones = 0;
        let mut zeros = 0;
        for number in numbers.iter() {
            if number[bit] {
                ones += 1;
            } else {
                zeros +=1;
            }
        }
        if ones > zeros {
            gamma += "1";
            epsilon += "0";
        } else {
            gamma += "0";
            epsilon += "1";
        }
    }
    println!("{}", isize::from_str_radix(&gamma[..], 2).unwrap() * isize::from_str_radix(&epsilon[..], 2).unwrap())
}