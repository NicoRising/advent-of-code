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
    let mut oxygen = numbers.clone();
    let mut co2 = numbers.clone();

    for bit in 0..binary_length as usize {
        if oxygen.len() > 1 {
            let ones = oxygen.iter().filter(|number| number[bit]).count() as u32;
            let mut next_oxygen = Vec::new();

            for number in oxygen.iter() {
                if (ones as f32 >= oxygen.len() as f32 / 2.0) == number[bit] {
                    next_oxygen.push(number.clone()); 
                }
            }

            oxygen = next_oxygen;
        }

        if co2.len() > 1 {
            let ones = co2.iter().filter(|number| number[bit]).count() as u32;
            let mut next_co2 = Vec::new();

            for number in co2.iter() {
                if (ones as f32 >= co2.len() as f32 / 2.0) != number[bit] {
                    next_co2.push(number.clone());
                }
            }

            co2 = next_co2;
        }
    }

    let oxygen_rating = oxygen.first().unwrap().iter().enumerate().fold(0, |acc, (bit, &on)| {
        if on {
            acc + 2_u32.pow(binary_length - bit as u32 - 1)
        } else {
            acc
        }
    });

    let co2_rating = co2.first().unwrap().iter().enumerate().fold(0, |acc, (bit, &on)| {
        if on {
            acc + 2_u32.pow(binary_length - bit as u32 - 1)
        } else {
            acc
        }
    });

    println!("{}", oxygen_rating * co2_rating);
}
