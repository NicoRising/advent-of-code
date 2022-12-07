use std::cmp::Reverse;
use std::collections::BinaryHeap;
use std::fs::File;
use std::io::Read;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut input = String::new();

    file.read_to_string(&mut input).unwrap();

    let mut grid: Vec<Vec<u32>> = Vec::new();

    for tile_y in 0..5 {
        for line in input.lines() {
            let mut tile_line = Vec::new();

            for tile_x in 0..5 {
                tile_line.extend(line.chars().map(|risk| {
                    (risk.to_digit(10).unwrap() + tile_x + tile_y - 1) % 9 + 1
                }));
            }

            grid.push(tile_line);
        }
    }

    let mut accum_risk = vec![vec![0; grid[0].len()]; grid.len()];

    let mut heap = BinaryHeap::new();
    heap.push((Reverse(0), (0, 0)));

    while let Some((Reverse(dist), (x, y))) = heap.pop() { // Thanks, Dijkstra
        if (x, y) == (grid.len() - 1, grid[0].len() - 1) {
            println!("{}", dist);
            break;
        }

        if dist <= accum_risk[x][y] {
            if x > 0 {
                let risk = dist + grid[x - 1][y];

                if accum_risk[x - 1][y] == 0 || risk < accum_risk[x - 1][y] {
                    accum_risk[x - 1][y] = risk;
                    heap.push((Reverse(risk), (x - 1, y)));
                }
            }

            if y > 0 {
                let risk = dist + grid[x][y - 1];

                if accum_risk[x][y - 1] == 0 || risk < accum_risk[x][y - 1] {
                    accum_risk[x][y - 1] = risk;
                    heap.push((Reverse(risk), (x, y - 1)));
                }
            }

            if x < grid.len() - 1 {
                let risk = dist + grid[x + 1][y];

                if accum_risk[x + 1][y] == 0 || risk < accum_risk[x + 1][y] {
                    accum_risk[x + 1][y] = risk;
                    heap.push((Reverse(risk), (x + 1, y)));
                }
            }

            if y < grid[0].len() - 1 {
                let risk = dist + grid[x][y + 1];

                if accum_risk[x][y + 1] == 0 || risk < accum_risk[x][y + 1] {
                    accum_risk[x][y + 1] = risk;
                    heap.push((Reverse(risk), (x, y + 1)));
                }
            }
        }
    }
}
