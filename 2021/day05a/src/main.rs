use std::fs::File;
use std::io::Read;

use regex::Regex;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut inputs = String::new();

    file.read_to_string(&mut inputs).unwrap();

    let number_regex = Regex::new(r"\d+").unwrap();

    let mut vert = Vec::new();
    let mut hor = Vec::new();
    let mut max_x = 0;
    let mut max_y = 0;

    for line in inputs.lines() {
        let numbers: Vec<usize> = number_regex.find_iter(line).map(
            |number| {
                number.as_str().parse::<usize>().unwrap()
            }
        ).collect();

        let x1 = numbers[0];
        let y1 = numbers[1];
        let x2 = numbers[2];
        let y2 = numbers[3];

        if x1 == x2 {
            if y2 > y1 {
                vert.push((x1, y1..=y2));

                if y2 > max_y {
                    max_y = y2;
                }
            } else {
                vert.push((x1, y2..=y1));

                if y1 > max_y {
                    max_y = y1;
                }
            }
            if x1 > max_x {
                max_x = x1;
            }
        } else if y1 == y2 {
            if x2 > x1 {
                hor.push((y1, x1..=x2));

                if x2 > max_x {
                    max_x = x2;
                }
            } else {
                hor.push((y1, x2..=x1));

                if x1 > max_x {
                    max_x = x1;
                }
            }
            if y1 > max_y {
                max_y = y1;
            }
        }
    }

    let mut grid: Vec<Vec<u32>> = vec![
        vec![0; max_y + 1]; max_x + 1
    ];

    let mut overlaps: u32 = 0;

    for (x, line) in vert {
        for y in line {
            grid[x][y] += 1;

            if grid[x][y] == 2 {
                overlaps += 1;
            }
        }
    }

    for (y, line) in hor {
        for x in line {
            grid[x][y] += 1;

            if grid[x][y] == 2 {
                overlaps += 1;
            }
        }
    }

    println!("{}", overlaps);
}
