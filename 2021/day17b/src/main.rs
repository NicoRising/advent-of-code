use std::fs::File;
use std::io::Read;

use regex::Regex;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut contents = String::new();
    file.read_to_string(&mut contents).unwrap();
    let number_regex = Regex::new(r"[-\d]+").unwrap();
    let mut number_strs = number_regex.captures_iter(&contents);
    let x_range = number_strs.next().unwrap()[0].parse::<i32>().unwrap()..=number_strs.next().unwrap()[0].parse::<i32>().unwrap();
    let y_range = number_strs.next().unwrap()[0].parse::<i32>().unwrap()..=number_strs.next().unwrap()[0].parse::<i32>().unwrap();
    let mut allowed_dx = Vec::new(); // Stores dx and the associated range of steps it will be in the target zone at
    for initial_dx in 0..=*x_range.end() { // Assumes target is >0 units to the right
        let mut x = 0;
        let mut dx = initial_dx;
        let mut step = 0;
        let mut enter = 0;
        loop {
            let contains = x_range.contains(&x);
            if enter == 0 && contains { // Probe entered target area
                enter = step;
            } else if enter != 0 && !contains { // Probe left target area
                allowed_dx.push((initial_dx, enter..step));
                break
            } else if dx == 0 && contains { // Probe is in target area with a dx of 0
                allowed_dx.push((initial_dx, enter..u32::MAX));
                break
            } else if dx == 0 && !contains { // Probe never made it to the target area and has a dx of 0
                break
            }
            x += dx;
            if dx > 0 {
                dx -= 1;
            }
            step += 1;
        }
    }
    let mut distinct: u32 = 0;
    for (_, steps) in allowed_dx {
        for initial_dy in *y_range.start()..(-y_range.start() + 1) { // Assumes target is below the x-axis
            let mut y = 0;
            let mut dy = initial_dy;
            let mut step = 0;
            while &y > y_range.end() || step < steps.start {
                y += dy;
                dy -= 1;
                step += 1;
            }
            if y_range.contains(&y) && steps.contains(&step) {
                distinct += 1;
            }
        }
    }
    println!("{}", distinct);
}