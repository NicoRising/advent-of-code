use std::fs::File;
use std::io::Read;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut contents = String::new();
    file.read_to_string(&mut contents).unwrap();
    let crabs: Vec<i32> = contents.split(',').map(|pos| pos.parse::<i32>().unwrap()).collect();
    let mut target = 0;
    let mut current_fuel = 0;
    for &crab in crabs.iter() {
        let diff = if crab > target { crab - target } else { target - crab };
        current_fuel += diff * (diff + 1) / 2;
    }
    loop {
        let mut left_fuel = 0;
        let mut right_fuel = 0;
        for &crab in crabs.iter() {
            let left_diff = if crab > target { crab - target + 1 } else { target - crab - 1};
            let right_diff = if crab > target { crab - target - 1 } else { target - crab + 1 };
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
            break
        }
    }
    println!("{}", current_fuel);
}