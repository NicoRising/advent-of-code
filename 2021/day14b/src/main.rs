use std::collections::HashMap;
use std::fs::File;
use std::io::Read;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut input = String::new();

    file.read_to_string(&mut input).unwrap();

    let mut pairs: HashMap<(char, char), u64> = HashMap::new();
    let initial = input.lines().nth(0).unwrap().to_string();

    for index in 0..(initial.len() - 1) {
        let pair = (initial.chars().nth(index).unwrap(), initial.chars().nth(index + 1).unwrap());

        if let Some(count) = pairs.get_mut(&pair) {
            *count += 1;
        } else {
            pairs.insert(pair, 1);
        }
    }

    let mut rules = HashMap::new();
 
    for line in input.lines() {
        if let Some((pair, element)) = line.split_once(" -> ") {
            rules.insert((
                pair.chars().nth(0).unwrap(),
                pair.chars().nth(1).unwrap()),
                element.chars().nth(0).unwrap()
            );
        }
    }

    for _ in 0..40 {
        let mut next_pairs = HashMap::new();

        for (pair, &old_count) in pairs.iter() {
            if let Some(&element) = rules.get(pair) {
                let left_pair = (pair.0, element);
                let right_pair = (element, pair.1);

                if let Some(new_count) = next_pairs.get_mut(&left_pair) {
                    *new_count += old_count;
                } else {
                    next_pairs.insert(left_pair, old_count);
                }

                if let Some(new_count) = next_pairs.get_mut(&right_pair) {
                    *new_count += old_count;
                } else {
                    next_pairs.insert(right_pair, old_count);
                }
            } else {
                next_pairs.insert(*pair, old_count);
            }
        }

        pairs = next_pairs;
    }

    let mut element_counts = HashMap::new();

    for (pair, pair_count) in pairs {
        if let Some(count) = element_counts.get_mut(&pair.0) {
            *count += pair_count;
        } else {
            element_counts.insert(pair.0, pair_count);
        }

        if let Some(count) = element_counts.get_mut(&pair.1) {
            *count += pair_count;
        } else {
            element_counts.insert(pair.1, pair_count);
        }
    }
    *element_counts.get_mut(
        &initial.chars().nth(0).unwrap()
    ).unwrap() += 2; // First and last elements aren't part of two pairs

    *element_counts.get_mut(&initial.chars().nth_back(0).unwrap()).unwrap() += 2;

    let count_iter = element_counts.iter().map(|(_, count)| count / 2);

    println!("{}", count_iter.clone().max().unwrap() - count_iter.clone().min().unwrap());
}
