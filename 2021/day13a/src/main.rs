use std::collections::HashSet;
use std::fs::File;
use std::io::Read;

enum Orientation {
    Horizontal, // Fold left-right
    Vertical // Fold up-down
}

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut contents = String::new();
    file.read_to_string(&mut contents).unwrap();
    let mut dots = HashSet::new();
    let mut folds = Vec::new();
    for line in contents.lines() {
        if let Some((x_str, y_str)) = line.split_once(',') {
            dots.insert((x_str.parse::<u32>().unwrap(), y_str.parse::<u32>().unwrap()));
        } else if !line.is_empty() {
            let orientation = if line.chars().nth(11).unwrap() == 'x' { Orientation::Horizontal } else { Orientation::Vertical };
            folds.push((orientation, line[13..].parse::<u32>().unwrap()));
        }
    }
    let mut overlaps: u32 = 0;
    let fold = &folds[0];
    for dot in dots.iter() {
        match fold.0 {
            Orientation::Horizontal => {
                if dot.0 < fold.1 {
                    if dots.contains(&(fold.1 * 2 - dot.0, dot.1)) {
                        overlaps += 1;
                    }
                }
            },
            Orientation::Vertical => {
                if dot.1 < fold.1 {
                    if dots.contains(&(dot.0, fold.1 * 2 - dot.1)) {
                        overlaps += 1;
                    }
                }
            }
        }
    }
    println!("{}", dots.len() as u32 - overlaps);
}