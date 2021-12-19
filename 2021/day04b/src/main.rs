use std::fs::File;
use std::io::Read;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut contents = String::new();
    file.read_to_string(&mut contents).unwrap();
    let lines: Vec<&str> = contents.split('\n').collect();
    let draws: Vec<u32> = lines[0].split(',').map(|draw_str| draw_str.parse::<u32>().unwrap()).collect();
    let mut boards: Vec<Vec<u32>> = Vec::new();
    for line in lines[1..].iter() {
        if line.is_empty() {
            boards.push(Vec::new());
        } else {
            let row = line.split_whitespace().map(|number_str| number_str.parse::<u32>().unwrap());
            boards.last_mut().unwrap().extend(row);
        }
    }
    let mut final_score = 0;
    for draw in draws.iter() {
        let mut winners = Vec::new();
        for (board_index, board) in boards.iter_mut().enumerate() {
            if let Some(index) = board.iter().position(|number| number == draw) {
                board[index] = 100;
                let mut is_won = true;
                for row in 0..5 {
                    if board[row * 5 + index % 5] != 100 {
                        is_won = false;
                        break
                    }
                }
                if is_won {
                    winners.push(board_index);
                    continue
                }
                is_won = true;
                for col in 0..5 {
                    if board[index / 5 * 5 + col] != 100 {
                        is_won = false;
                        break
                    }
                }
                if is_won {
                    winners.push(board_index)
                }
            }
        }
        if winners.len() > 1 {
            for winner_index in winners.into_iter().rev() { // Reverses to prevent indexing issues
                boards.swap_remove(winner_index);
            }
        } else if winners.len() == 1 {
            let winner = boards.swap_remove(*winners.first().unwrap());
            let mut sum = 0;
            for index in 0..25 {
                if winner[index] != 100 {
                    sum += winner[index];
                }
            }
            final_score = sum * draw;
        }
        if boards.is_empty() {
            println!("{}", final_score);
            break
        }
    }
}