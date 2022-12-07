use std::collections::HashSet;
use std::fs::File;
use std::io::Read;

enum Orientation {
    Horizontal, // Fold left-right
    Vertical // Fold up-down
}

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut input = String::new();

    file.read_to_string(&mut input).unwrap();

    let mut dots = HashSet::new();
    let mut folds = Vec::new();

    for line in input.lines() {
        if let Some((x_str, y_str)) = line.split_once(',') {
            dots.insert((x_str.parse::<u32>().unwrap(), y_str.parse::<u32>().unwrap()));
        } else if !line.is_empty() {
            let orientation = if line.chars().nth(11).unwrap() == 'x' {
                Orientation::Horizontal
            } else {
                Orientation::Vertical
            };

            folds.push((orientation, line[13..].parse::<u32>().unwrap()));
        }
    }

    for fold in folds {
        let mut folded_dots = Vec::new();

        for &(x, y) in dots.iter() {
            match fold.0 {
                Orientation::Horizontal => {
                    if x > fold.1 {
                        folded_dots.push(((x, y), (fold.1 * 2 - x, y)));
                    }
                },
                Orientation::Vertical => {
                    if y > fold.1 {
                        folded_dots.push(((x, y), (x, fold.1 * 2 - y)));
                    }
                }
            }
        }
        for (old, new) in folded_dots {
            dots.remove(&old);
            dots.insert(new);
        }
    }

    let mut min_x = u32::MAX;
    let mut min_y = u32::MAX;
    let mut max_x = 0;
    let mut max_y = 0;

    for &(x, y) in dots.iter() {
        if x < min_x {
            min_x = x;
        }
        if y < min_y {
            min_y = y;
        }
        if x > max_x {
            max_x = x;
        }
        if y > max_y {
            max_y = y;
        }
    }

    let mut code = String::new();

    for y in min_y..=max_y {
        for x in min_x..=max_x {
            if dots.contains(&(x, y)) {
                code.push('#');
            } else {
                code.push(' ');
            }
        }

        if y != max_y {
            code.push('\n');
        }
    }

    println!("{}", code);
}
