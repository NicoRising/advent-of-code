use std::fs::File;
use std::io::Read;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut input = String::new();

    file.read_to_string(&mut input).unwrap();

    let mut points_list = Vec::new();

    for line in input.lines() {
        let mut incomplete = true;
        let mut stack = Vec::new();

        for chr in line.chars() {
            match chr {
                '(' | '[' | '{' | '<' => stack.push(chr),
                ')' => if stack.pop().unwrap() != '(' {
                    incomplete = false;
                    break;
                },
                ']' => if stack.pop().unwrap() != '[' {
                    incomplete = false;
                    break;
                },
                '}' => if stack.pop().unwrap() != '{' {
                    incomplete = false;
                    break;
                },
                '>' => if stack.pop().unwrap() != '<' {
                    incomplete = false;
                    break;
                },
                _ => ()
            }
        }

        if incomplete {
            let mut points: u64 = 0;

            for chr in stack.iter().rev() {
                points *= 5;
                points += match chr {
                    '(' => 1,
                    '[' => 2,
                    '{' => 3,
                    '<' => 4,
                    _ => 0
                }
            }

            points_list.push(points);
        }
    }

    points_list.sort();

    println!("{}", points_list[points_list.len() / 2]);
}
