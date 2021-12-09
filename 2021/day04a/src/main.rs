use std::fs::File;
use std::io::Read;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut contents = String::new();
    file.read_to_string(&mut contents).unwrap();
    let lines: Vec<String> = contents.split("\n").map(|num| num.to_string()).collect();
    let draws: Vec<u32> = lines.first().unwrap().split(",").map(|num| num.parse::<u32>().unwrap()).collect();
    let mut boards: Vec<(Vec<u32>, u32)> = Vec::new();
    let mut board: (Vec<u32>, u32) = (Vec::new(), 0);
    for line in lines[2..].iter() {
        if line.is_empty() {
            boards.push(board);
            board = (Vec::new(), 0);
        } else {
            let mut nums = Vec::new();
            for num in line.split(" ") {
                if !num.is_empty() {
                    nums.push(num.parse::<u32>().unwrap());
                }
            }
            board.1 += nums.iter().sum::<u32>();
            board.0.append(&mut nums);
        }
    }
    for draw in draws.iter() {
        let mut indicies = Vec::new();
        for board in boards.iter() {
            indicies.push(board.0.iter().position(|num| num == draw));
        }
        for index in 0..boards.len() {
            if let Some(board_index) = indicies[index] {
                println!("{}",boards[index].1);
                boards[index].1 -= boards[index].0[board_index];
                println!("{}\n",boards[index].1);
                boards[index].0[board_index] = 100;
            }
        }
        let mut bingo = false;
        for board in boards.iter() {
            for row in 0..5 {
                let mut possible = true;
                for index in (row * 5)..((row + 1) * 5) {
                    if board.0[index] != 100 {
                        possible = false;
                        break
                    }
                }
                if possible {
                    bingo = true;
                    break
                }
            }
            for col in 0..5 {
                let mut possible = true;
                for index in (col..(col + 20)).step_by(5) {
                    if board.0[index] != 100 {
                        possible = false;
                        break
                    }
                }
                if possible {
                    bingo = true;
                    break
                }
            }
        }
        if bingo {
            println!("{:?}", board.0);
            println!("{}", board.1);
            break
        }
    }
}