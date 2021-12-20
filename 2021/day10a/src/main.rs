use std::fs::File;
use std::io::Read;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut contents = String::new();
    file.read_to_string(&mut contents).unwrap();
    let mut points: u32 = 0;
    for line in contents.lines() {
        let mut stack = Vec::new();
        for chr in line.chars() {
            match chr {
                '(' | '[' | '{' | '<' => stack.push(chr),
                ')' => if stack.pop().unwrap() != '(' {
                    points += 3;
                    break
                },
                ']' => if stack.pop().unwrap() != '[' {
                    points += 57;
                    break
                },
                '}' => if stack.pop().unwrap() != '{' {
                    points += 1197;
                    break
                },
                '>' => if stack.pop().unwrap() != '<' {
                    points += 25137;
                    break
                },
                _ => ()
            }
        }
    }
    println!("{}", points);
}