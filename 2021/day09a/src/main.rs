use std::fs::File;
use std::io::Read;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut input = String::new();

    file.read_to_string(&mut input).unwrap();

    let mut heights: [[u8; 100]; 100] = [[0; 100]; 100];

    for (row, line) in input.lines().enumerate() {
        for (col, chr) in line.chars().enumerate() {
            heights[col][row] = chr as u8 - 48;
        }
    }

    let mut risk: u32 = 0;

    for x in 0..heights.len() {
        for y in 0..heights[x].len() {
            let current = heights[x][y];
            
            let skip = x > 0 && heights[x - 1][y] <= current ||
                       y > 0 && heights[x][y - 1] <= current ||
                       x < heights.len() - 1 && heights[x + 1][y] <= current ||
                       y < heights[x].len() - 1 && heights[x][y + 1] <= current;

            if !skip {
                risk += current as u32 + 1;
            }
        }
    }

    println!("{}", risk);
}
