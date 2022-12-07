use std::collections::HashMap;
use std::fs::File;
use std::io::Read;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut input = String::new();

    file.read_to_string(&mut input).unwrap();

    let mut connects: HashMap<&str, Vec<&str>> = HashMap::new();

    for line in input.lines() {
        let (name_a, name_b) = line.split_once('-').unwrap();

        if let Some(connect) = connects.get_mut(&name_a) {
            connect.push(name_b.clone());
        } else {
            connects.insert(name_a.clone(), vec![name_b.clone()]);
        }

        if let Some(connect) = connects.get_mut(&name_b) {
            connect.push(name_a);
        } else {
            connects.insert(name_b, vec![name_a]);
        }
    }

    let mut queue = vec![("start", vec!["start"])];
    let mut paths = Vec::new();

    while let Some((current, path)) = queue.pop() {
        for neighbor in connects.get(current).unwrap().iter() {
            if neighbor.chars().next().unwrap().is_uppercase() || !path.contains(neighbor) {
                let mut next_path = path.clone();
                next_path.push(neighbor);

                if *neighbor == "end" {
                    paths.push(next_path);
                } else {
                    queue.push((neighbor, next_path));
                }
            }
        }
    }

    println!("{}", paths.len());
}
