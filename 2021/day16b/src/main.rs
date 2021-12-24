use std::fs::File;
use std::io::Read;

#[derive(Debug)]
enum PacketKind {
    Value(u64),
    Operator(Vec<Packet>)
}

#[derive(Debug)]
struct Packet {
    pub _version: u8,
    pub type_id: u8,
    pub kind: PacketKind
}

impl Packet {
    fn new(bits: Vec<bool>) -> (Packet, usize) { // Returns a Packet and the index immediately following it
        let mut version = 0; // Yeah, it's kinda a mess
        for (magnitude, &bit) in bits[0..3].iter().rev().enumerate() {
            if bit {
                version += 2_u8.pow(magnitude as u32);
            }
        }
        let mut type_id = 0;
        for (magnitude, &bit) in bits[3..6].iter().rev().enumerate() {
            if bit {
                type_id += 2_u8.pow(magnitude as u32);
            }
        }
        let mut index = 7;
        if type_id == 4 {
            let mut end = 6;
            while bits[end] {
                end += 5;
            }
            end += 5;
            let mut value = 0;
            let mut magnitude = end - (end - 6) / 5 - 7;
            loop {
                if index % 5 != 1 {
                    if bits[index] {
                        value += 2_u64.pow(magnitude as u32);
                    }
                    if magnitude == 0 {
                        break
                    }
                    magnitude -= 1;
                }
                index += 1;
            }
            index += 1;
            (Packet { _version: version, type_id, kind: PacketKind::Value(value) }, index)
        } else {
            let mut children = Vec::new();
            if bits[6] {
                let mut packet_count = 0;
                while index < 18 {
                    if bits[index] {
                        packet_count += 2_u32.pow(17 - index as u32)
                    }
                    index += 1;
                }
                for _ in 0..packet_count {
                    let (packet, end_index) = Packet::new(bits[index..].to_vec());
                    children.push(packet);
                    index += end_index;
                }
            } else {
                let mut packets_end = 22;
                while index < 22 {
                    if bits[index] {
                        packets_end += 2_usize.pow(21 - index as u32)
                    }
                    index += 1
                }
                while index < packets_end {
                    let (packet, end_index) = Packet::new(bits[index..].to_vec());
                    children.push(packet);
                    index += end_index;
                }
            }
            (Packet { _version: version, type_id, kind: PacketKind::Operator(children) }, index)
        }
    }
}

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut contents = String::new();
    file.read_to_string(&mut contents).unwrap();
    let mut bits = Vec::new();
    for byte in hex::decode(contents.lines().nth(0).unwrap()).unwrap() {
        for index in (0..8).rev() {
            bits.push(if index != 7 { byte % 2_u8.pow(index + 1) } else { byte } >= 2_u8.pow(index));
        }
    }
    println!("{}", solve(&Packet::new(bits).0));
}

fn solve(packet: &Packet) -> u64 {
    match &packet.kind {
        PacketKind::Value(value) => *value,
        PacketKind::Operator(operands) => {
            match packet.type_id {
                0 => operands.iter().map(|operand| solve(operand)).sum(),
                1 => {
                    let mut product = 1;
                    for operand in operands.iter() {
                        product *= solve(operand);
                    }
                    product
                },
                2 => operands.iter().map(|operand| solve(operand)).min().unwrap(),
                3 => operands.iter().map(|operand| solve(operand)).max().unwrap(),
                5 => (solve(&operands[0]) > solve(&operands[1])) as u64,
                6 => (solve(&operands[0]) < solve(&operands[1])) as u64,
                7 => (solve(&operands[0]) == solve(&operands[1])) as u64,
                _ => 0
            }
        }
    }
}