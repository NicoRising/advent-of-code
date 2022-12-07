use std::fs::File;
use std::io::Read;

use num::pow;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut input = String::new();

    file.read_to_string(&mut input).unwrap();

    let mut total: u32 = 0;

    for line in input.lines() {
        let (signal_str, output_str) = line.split_once('|').unwrap();

        let chr_to_int = |number_str: &str| {
            let mut number: Vec<u8> = number_str.chars().map(|chr| chr as u8 - 97).collect();
            number.sort();

            number
        };

        let signals: Vec<Vec<u8>> = signal_str.split_whitespace().map(chr_to_int).collect();
        let outputs: Vec<Vec<u8>> = output_str.split_whitespace().map(chr_to_int).collect();

        let mut decode: [Vec<u8>; 10] = Default::default();

        for number in signals.iter() {
            match number.len() {
                2 => decode[1] = number.clone(),
                3 => decode[7] = number.clone(),
                4 => decode[4] = number.clone(),
                7 => decode[8] = number.clone(),
                _ => ()
            }
        }

        loop {
            for number in signals.iter() {
                if number.len() == 5 && number.contains(&decode[1][0]) && number.contains(&decode[1][1]) {
                    decode[3] = number.clone();
                } else if number.len() == 5 && !decode[3].is_empty() && number != &decode[3] {
                    if overlap(&number, &decode[4]) == 3 {
                        decode[5] = number.clone();
                    } else {
                        decode[2] = number.clone();
                    }
                } else if number.len() == 6 {
                    if overlap(&number, &decode[4]) == 4 {
                        decode[9] = number.clone();
                    } else if !decode[5].is_empty() {
                        if overlap(&number, &decode[5]) == 5 {
                            decode[6] = number.clone();
                        } else {
                            decode[0] = number.clone();
                        }
                    }
                }
            }

            let mut solved = true;

            for number in decode.iter() {
                if number.is_empty() {
                    solved = false;
                    break;
                }
            }

            if solved {
                break;
            }
        }
        for index in 0..4 {
            total += (decode.iter().position(
                        |number| number == &outputs[index]
                     ).unwrap() * pow(10, 3 - index)) as u32;
        }
    }
    println!("{}", total);
}

fn overlap(a: &Vec<u8>, b: &Vec<u8>) -> u8 {
    let mut overlap: u8 = 0;

    for segment in a.iter() {
        if b.contains(segment) {
            overlap += 1;
        }
    }

    overlap
}
