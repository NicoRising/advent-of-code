use std::collections::HashSet;
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
    let mut low_points = Vec::new();
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
            low_points.push((x, y));
        }
    }
    let mut basins = Vec::new();
    for low_point in low_points {
        let mut queue = vec![low_point];
        let mut visited = HashSet::new();
        let mut size: u32 = 0;
        while let Some((x, y)) = queue.pop() {
            if !visited.contains(&(x, y)) {
                visited.insert((x, y));
                if x > 0 && heights[x - 1][y] != 9 {
                    queue.push((x - 1, y));
                }
                if y > 0 && heights[x][y - 1] != 9 {
                    queue.push((x, y - 1));
                }
                if x < heights.len() - 1 && heights[x + 1][y] != 9 {
                    queue.push((x + 1, y));
                }
                if y < heights[x].len() - 1 && heights[x][y + 1] != 9 {
                    queue.push((x, y + 1));
                }
                size += 1;
            }
        }
        basins.push(size);
    }
    let mut largest: [u32; 3] = [0; 3];
    for basin in basins {
        if basin > largest[2] {
            largest[0] = largest[1];
            largest[1] = largest[2];
            largest[2] = basin;
        } else if basin > largest[1] {
            largest[0] = largest[1];
            largest[1] = basin;
        } else if basin > largest[0] {
            largest[0] = basin;
        }
    }
    println!("{}", largest[0] * largest[1] * largest[2]);
}