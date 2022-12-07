use std::fs::File;
use std::io::Read;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut input = String::new();

    file.read_to_string(&mut input).unwrap();

    let lines: Vec<&str> = input.lines().collect();

    let draws: Vec<u32> = lines[0].split(',').map(
        |draw_str| draw_str.parse::<u32>().unwrap()
    ).collect();

    let mut boards: Vec<Vec<u32>> = Vec::new();

    for line in lines[1..].iter() {
        if line.is_empty() {
            boards.push(Vec::new());
        } else {
            let row = line.split_whitespace().map(
                |number_str| number_str.parse::<u32>().unwrap()
            );

            boards.last_mut().unwrap().extend(row);
        }
    }

    for draw in draws.iter() {
        let mut winner = None;

        for board in boards.iter_mut() {
            if let Some(index) = board.iter().position(|number| number == draw) {
                board[index] = 100;
                let mut is_won = true;

                for row in 0..5 {
                    if board[row * 5 + index % 5] != 100 {
                        is_won = false;
                        break;
                    }
                }

                if is_won {
                    winner = Some(board);
                    break;
                }

                is_won = true;

                for col in 0..5 {
                    if board[index / 5 * 5 + col] != 100 {
                        is_won = false;
                        break;
                    }
                }

                if is_won {
                    winner = Some(board);
                }
            }
        }

        if let Some(board) = winner {
            let mut sum = 0;

            for index in 0..25 {
                if board[index] != 100 {
                    sum += board[index];
                }
            }

            println!("{}", sum * draw);
            break;
        }
    }
}
