const std = @import("std");

fn solve(input: []const u8) !u32 {
    var safe_count: u32 = 0;

    var line_iter = std.mem.tokenizeScalar(u8, input, '\n');
    while (line_iter.next()) |line| {
        var num_iter = std.mem.tokenizeScalar(u8, line, ' ');

        var last_level = try std.fmt.parseInt(i32, num_iter.next().?, 10);
        var is_increasing = true;
        var is_decreasing = true;

        while (num_iter.next()) |num| {
            const curr_level = try std.fmt.parseInt(i32, num, 10);
            const diff = curr_level - last_level;

            if (diff <= 0 or @abs(diff) > 3) {
                is_increasing = false;
            }
            if (diff >= 0 or @abs(diff) > 3) {
                is_decreasing = false;
            }

            last_level = curr_level;
        }

        if (is_increasing or is_decreasing) {
            safe_count += 1;
        }
    }

    return safe_count;
}

pub fn main() !void {
    const input = @embedFile("input.txt");
    const result = try solve(input);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}\n", .{result});
}

test "test day01b" {
    const input = @embedFile("test_data/day02.txt");
    const result = try solve(input);

    try std.testing.expectEqual(2, result);
}
