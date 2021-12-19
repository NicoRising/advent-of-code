use std::collections::HashMap;
use std::fs::File;
use std::io::Read;

use regex::Regex;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut contents = String::new();
    file.read_to_string(&mut contents).unwrap();
    let number_regex = Regex::new(r"\d+").unwrap();
    let mut points: HashMap<(u32, u32), u32> = HashMap::new();
    let mut overlaps: u32 = 0;
    for line in contents.split('\n') {
        let numbers: Vec<u32> = number_regex.find_iter(line).map(|number| {
            number.as_str().parse::<u32>().unwrap()
            }).collect();
        let x1 = numbers[0];
        let y1 = numbers[1];
        let x2 = numbers[2];
        let y2 = numbers[3];
        if x1 == x2 {
            for y in if y2 > y1 { y1..=y2 } else { y2..=y1 } {
                if let Some(vents) = points.get_mut(&(x1, y)) {
                    *vents += 1;
                    if *vents == 2 {
                        overlaps += 1;
                    }
                } else {
                    points.insert((x1, y), 1);
                }
            }
        } else if y1 == y2 {
            for x in if x2 > x1 { x1..=x2 } else { x2..=x1 } {
                if let Some(vents) = points.get_mut(&(x, y1)) {
                    *vents += 1;
                    if *vents == 2 {
                        overlaps += 1;
                    }
                } else {
                    points.insert((x, y1), 1);
                }
            }
        } else if x1 + y2 == y1 + x2 {
            let lower_x = if x2 > x1 { x1 } else { x2 };
            let lower_y = if y2 > y1 { y1 } else { y2 };
            for offset in if x2 > x1 { 0..=(x2 - x1) } else { 0..=(x1 - x2) } {
                if let Some(vents) = points.get_mut(&(lower_x + offset, lower_y + offset)) {
                    *vents += 1;
                    if *vents == 2 {
                        overlaps += 1;
                    }
                } else {
                    points.insert((lower_x + offset, lower_y + offset), 1);
                }
            }
        } else if x1 + y1 == x2 + y2 {
            let lower_x = if x2 > x1 { x1 } else { x2 };
            let upper_y = if y2 > y1 { y2 } else { y1 };
            for offset in if x2 > x1 { 0..=(x2 - x1) } else { 0..=(x1 - x2) } {
                if let Some(vents) = points.get_mut(&(lower_x + offset, upper_y - offset)) {
                    *vents += 1;
                    if *vents == 2 {
                        overlaps += 1;
                    }
                } else {
                    points.insert((lower_x + offset, upper_y - offset), 1);
                }
            }
        }
    }
    println!("{}", overlaps);
}