use std::fs::File;
use std::io::Read;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut input = String::new();

    file.read_to_string(&mut input).unwrap();

    let mut octopodes: [[(u8, bool); 10]; 10] = Default::default();

    for (y, line) in input.lines().enumerate() {
        for (x, chr) in line.chars().enumerate() {
            octopodes[x][y].0 = chr.to_digit(10).unwrap() as u8;
        }
    }

    let mut flashes: u32 = 0;

    for _ in 0..100 {
        for x in 0..octopodes.len() {
            for y in 0..octopodes[x].len() {
                octopodes[x][y].0 += 1;
                octopodes[x][y].1 = false;
            }
        }

        loop {
            let prev_flashes = flashes;

            for x in 0..octopodes.len() {
                for y in 0..octopodes[x].len() {
                    if octopodes[x][y].0 > 9 && !octopodes[x][y].1 {
                        flashes += 1;
                        octopodes[x][y].1 = true;

                        if x > 0 {
                            octopodes[x - 1][y].0 += 1;

                            if y > 0 {
                                octopodes[x - 1][y - 1].0 += 1;
                            }
                            if y < octopodes[x - 1].len() - 1 {
                                octopodes[x - 1][y + 1].0 += 1;
                            }
                        }

                        if x < octopodes.len() - 1 {
                            octopodes[x + 1][y].0 += 1;

                            if y > 0 {
                                octopodes[x + 1][y - 1].0 += 1;
                            }
                            if y < octopodes[x + 1].len() - 1 {
                                octopodes[x + 1][y + 1].0 += 1;
                            }
                        }

                        if y > 0 {
                            octopodes[x][y - 1].0 += 1;
                        }

                        if y < octopodes[x].len() - 1 {
                            octopodes[x][y + 1].0 += 1;
                        }
                    }
                }
            }

            if flashes == prev_flashes {
                break;
            }
        }

        for x in 0..octopodes.len() {
            for y in 0..octopodes[x].len() {
                if octopodes[x][y].1 {
                    octopodes[x][y].0 = 0;
                }
            }
        }
    }

    println!("{}", flashes);
}
