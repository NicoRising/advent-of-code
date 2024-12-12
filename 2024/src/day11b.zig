const std = @import("std");

const State = struct { mark: u64, blinks_left: u64 };

fn blink(mark: u64, blinks_left: u64, cache: *std.AutoHashMap(State, u64)) !u64 {
    if (blinks_left == 0) {
        return 1;
    }

    const state = State{ .mark = mark, .blinks_left = blinks_left };
    if (cache.get(state)) |count| {
        return count;
    }

    var count: u64 = undefined;

    if (mark == 0) {
        count = try blink(1, blinks_left - 1, cache);
    } else {
        const log = std.math.log10(mark);

        if (log % 2 == 1) {
            const divisor = std.math.pow(u64, 10, log / 2 + 1);
            count = try blink(mark / divisor, blinks_left - 1, cache);
            count += try blink(mark % divisor, blinks_left - 1, cache);
        } else {
            count = try blink(mark * 2024, blinks_left - 1, cache);
        }
    }

    try cache.put(state, count);
    return count;
}

fn solve(input: []const u8) !u64 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var cache = std.AutoHashMap(State, u64).init(allocator);
    defer cache.deinit();

    var stones: u64 = 0;

    var num_iter = std.mem.tokenizeScalar(u8, input[0 .. input.len - 1], ' ');
    while (num_iter.next()) |num| {
        const mark = try std.fmt.parseInt(u64, num, 10);
        stones += try blink(mark, 75, &cache);
    }

    return stones;
}

pub fn main() !void {
    const input = @embedFile("input.txt");
    const result = try solve(input);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}\n", .{result});
}
