const std = @import("std");

fn isPossible(pattern: []const u8, towels: [][]const u8) bool {
    if (pattern.len == 0) {
        return true;
    }

    for (towels) |towel| {
        if (std.mem.startsWith(u8, pattern, towel)) {
            if (isPossible(pattern[towel.len..pattern.len], towels)) {
                return true;
            }
        }
    }

    return false;
}

fn solve(input: []const u8) !u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var line_iter = std.mem.tokenizeScalar(u8, input, '\n');

    var towels = std.ArrayList([]const u8).init(allocator);
    defer towels.deinit();

    const towel_str = line_iter.next().?;
    var towel_iter = std.mem.tokenizeAny(u8, towel_str, ", ");

    while (towel_iter.next()) |towel| {
        try towels.append(towel);
    }

    var count: u32 = 0;

    while (line_iter.next()) |pattern| {
        if (isPossible(pattern, towels.items)) {
            count += 1;
        }
    }

    return count;
}

pub fn main() !void {
    const input = @embedFile("input.txt");
    const result = try solve(input);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}\n", .{result});
}

test "test day19a" {
    const input = @embedFile("test_data/day19.txt");
    const result = try solve(input);

    try std.testing.expectEqual(6, result);
}
