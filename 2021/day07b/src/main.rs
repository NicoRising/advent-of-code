use std::fs::File;
use std::io::Read;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut input = String::new();
    
    file.read_to_string(&mut input).unwrap();
    input.pop(); // Remove the newline

    let crabs: Vec<u32> = input.split(',').map(
        |pos| pos.parse::<u32>().unwrap()
    ).collect();

    let mut target = 0;
    let mut current_fuel = 0;

    for &crab in crabs.iter() {
        let diff = crab.abs_diff(target);
        current_fuel += diff * (diff + 1) / 2; // Simple arithmetic sequence formula

    }

    loop {
        let mut left_fuel = 0;
        let mut right_fuel = 0;

        for &crab in crabs.iter() {
            let diff = crab.abs_diff(target);

            let mut left_diff = diff;
            let mut right_diff = diff;

            if crab > target {
                left_diff += 1;
                right_diff -= 1;
            } else if crab < target {
                left_diff -= 1;
                right_diff += 1;
            }

            left_fuel += left_diff * (left_diff + 1) / 2;
            right_fuel += right_diff * (right_diff + 1) / 2;
        }

        if left_fuel < current_fuel {
            target -= 1;
            current_fuel = left_fuel;
        } else if right_fuel < current_fuel {
            target += 1;
            current_fuel = right_fuel;
        } else {
            println!("{}", current_fuel);
            break;
        }
    }
}
