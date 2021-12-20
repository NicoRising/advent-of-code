use std::fs::File;
use std::io::Read;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut contents = String::new();
    file.read_to_string(&mut contents).unwrap();
    let mut heights: [[u8; 100]; 100] = [[0; 100]; 100];
    for (row, line) in contents.lines().enumerate() {
        for (col, chr) in line.chars().enumerate() {
            heights[col][row] = chr as u8 - 48;
        }
    }
    let mut risk: u32 = 0;
    for x in 0..heights.len() {
        for y in 0..heights[x].len() {
            let current = heights[x][y];
            if x > 0 && heights[x - 1][y] <= current {
                continue
            }
            if y > 0 && heights[x][y - 1] <= current {
                continue
            }
            if x < heights.len() - 1 && heights[x + 1][y] <= current {
                continue
            }
            if y < heights[x].len() - 1 && heights[x][y + 1] <= current {
                continue
            }
            risk += current as u32 + 1;
        }
    }
    println!("{}", risk);
}