use std::fs::File;
use std::io::Read;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut contents = String::new();
    file.read_to_string(&mut contents).unwrap();
    let initial: Vec<usize> = contents.split(',').map(|age| age.parse::<usize>().unwrap()).collect();
    let mut new_fish: [u64; 256] = [0; 256];
    new_fish[0] = 1;
    let mut next_day = 7;
    while next_day < new_fish.len() {
        new_fish[next_day] += 1;
        next_day += 7;
    }
    for day in 0..new_fish.len() {
        let mut next_day = day + 9;
        while next_day < new_fish.len() {
            new_fish[next_day] += new_fish[day];
            next_day += 7;
        }
    }
    let mut last_week_totals = [0; 7];
    for index in 0..last_week_totals.len() {
        last_week_totals[index] = new_fish[0..(new_fish.len() + index - 7)].iter().sum::<u64>() + 1;
    }
    let mut total = 0;
    for age in initial {
        total += last_week_totals[7 - age];
    }
    println!("{}", total);

}