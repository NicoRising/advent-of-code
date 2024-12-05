const std = @import("std");

fn solve(input: []const u8) !u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var safe_count: u32 = 0;

    var line_iter = std.mem.tokenizeScalar(u8, input, '\n');
    while (line_iter.next()) |line| {
        var levels = std.ArrayList(i32).init(allocator);
        defer levels.deinit();

        var num_iter = std.mem.tokenizeScalar(u8, line, ' ');
        while (num_iter.next()) |num| {
            try levels.append(try std.fmt.parseInt(i32, num, 10));
        }

        var skip: usize = 0;
        while (skip < levels.capacity) : (skip += 1) {
            var is_increasing = true;
            var is_decreasing = true;

            var idx: usize = if (skip != 0) 0 else 1;
            while (idx + 1 < levels.items.len) : (idx += 1) {
                if (skip != idx) {
                    const next_idx = if (idx + 1 != skip) idx + 1 else idx + 2;

                    if (next_idx < levels.items.len) {
                        const diff = levels.items[idx] - levels.items[next_idx];

                        if (diff <= 0 or @abs(diff) > 3) {
                            is_increasing = false;
                        }
                        if (diff >= 0 or @abs(diff) > 3) {
                            is_decreasing = false;
                        }
                    }
                }
            }

            if (is_increasing or is_decreasing) {
                safe_count += 1;
                break;
            }
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

    try std.testing.expectEqual(4, result);
}
