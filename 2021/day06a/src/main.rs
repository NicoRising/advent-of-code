use std::fs::File;
use std::io::Read;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut input = String::new();

    file.read_to_string(&mut input).unwrap();
    input.pop(); // Remove the newline

    let mut fish: Vec<u32> = input.split(',').map(
        |age| age.parse::<u32>().unwrap()
    ).collect();

    for _ in 0..80 {
        let mut new_fish = 0;

        for age in fish.iter_mut() {
            if *age == 0 {
                *age = 6;
                new_fish += 1;
            } else {
                *age -= 1;
            }
        }

        fish.append(&mut vec![8; new_fish]);
    }

    println!("{}", fish.len());
}
