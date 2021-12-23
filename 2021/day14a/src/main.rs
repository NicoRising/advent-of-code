use std::collections::HashMap;
use std::fs::File;
use std::io::Read;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut contents = String::new();
    file.read_to_string(&mut contents).unwrap();
    let mut polymer = contents.lines().nth(0).unwrap().to_string();
    let mut elements = HashMap::new();
    for element in polymer.chars() {
        if let Some(count) = elements.get_mut(&element) {
            *count += 1;
        } else {
            elements.insert(element, 1);
        }
    }
    let mut rules = HashMap::new();
    for line in contents.lines() {
        if let Some((pair, element)) = line.split_once(" -> ") {
            rules.insert(pair, element.chars().nth(0).unwrap());
        }
    }
    for _ in 0..10 {
        let mut index = 0;
        while index < polymer.len() - 1 {
            if let Some(&element) = rules.get(&polymer[index..(index + 2)]) {
                polymer.insert(index + 1, element);
                if let Some(count) = elements.get_mut(&element) {
                    *count += 1;
                } else {
                    elements.insert(element, 1);
                }
                index += 1;
            }
            index += 1;
        }
    }
    let count_iter = elements.iter().map(|(_, count)| count);
    println!("{}", count_iter.clone().max().unwrap() - count_iter.clone().min().unwrap());
}