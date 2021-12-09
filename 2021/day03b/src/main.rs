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
    let mut oxygen = numbers.clone();
    let mut co2 = numbers.clone();
    for bit in 0..12 {
        if oxygen.len() > 1 {

            let mut ones = 0;
            let mut zeros = 0;
            for number in oxygen.iter() {
                if number[bit] {
                    ones += 1;
                } else {
                    zeros +=1;
                }
            }
            let mut next_oxygen = Vec::new();
            for number in oxygen.iter() {
                if ones >= zeros && number[bit] {
                    next_oxygen.push(number.clone());
                } else if ones < zeros && !number[bit] {
                    next_oxygen.push(number.clone()); 
                }
            }
            oxygen = next_oxygen;
        }
        if co2.len() > 1 {

            let mut ones = 0;
            let mut zeros = 0;
            for number in co2.iter() {
                if number[bit] {
                    ones += 1;
                } else {
                    zeros +=1;
                }
            }
            println!("{}, {}", ones, zeros);
            let mut next_co2 = Vec::new();
            for number in co2.iter() {
                if ones >= zeros && !number[bit] {
                    next_co2.push(number.clone());
                } else if ones < zeros && number[bit] {
                    next_co2.push(number.clone()); 
                }
            }
            co2 = next_co2;
        }
    }
    println!("{:?}, {:?}", &oxygen.first(), &co2.first())
}