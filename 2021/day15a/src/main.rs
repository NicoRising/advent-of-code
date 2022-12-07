use std::fs::File;
use std::io::Read;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut input = String::new();

    file.read_to_string(&mut input).unwrap();

    let mut grid: Vec<Vec<u32>> = Vec::new();

    for line in input.lines() {
        grid.push(line.chars().map(|risk| risk.to_digit(10).unwrap()).collect());
    }

    let mut accum_risk = vec![vec![0; grid[0].len()]; grid.len()];
    let mut queue = vec![(0, 0)];

    while let Some((x, y)) = queue.pop() {
        if x < grid.len() - 1 {
            if accum_risk[x + 1][y] == 0 {
                accum_risk[x + 1][y] = accum_risk[x][y] + grid[x + 1][y];
                queue.push((x + 1, y));
            } else {
                let possible_risk = accum_risk[x][y] + grid[x + 1][y];

                if possible_risk < accum_risk[x + 1][y] {
                    accum_risk[x + 1][y] = possible_risk;
                    queue.push((x + 1, y));
                }
            }
        }

        if y < grid[x].len() - 1 {
            if accum_risk[x][y + 1] == 0 {
                accum_risk[x][y + 1] = accum_risk[x][y] + grid[x][y + 1];
                queue.push((x, y + 1));
            } else {
                let possible_risk = accum_risk[x][y] + grid[x][y + 1];

                if possible_risk < accum_risk[x][y + 1] {
                    accum_risk[x][y + 1] = possible_risk;
                    queue.push((x, y + 1));
                }
            }
        }
    }

    println!("{}", accum_risk[grid.len() - 1][grid[0].len() - 1]);
}
