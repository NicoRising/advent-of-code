const std = @import("std");

fn possibleCount(pattern: []const u8, towels: [][]const u8, cache: *std.StringHashMap(u64)) !u64 {
    if (pattern.len == 0) {
        return 1;
    }
    if (cache.get(pattern)) |count| {
        return count;
    }

    var sum: u64 = 0;

    for (towels) |towel| {
        if (std.mem.startsWith(u8, pattern, towel)) {
            sum += try possibleCount(pattern[towel.len..pattern.len], towels, cache);
        }
    }

    try cache.put(pattern, sum);
    return sum;
}

fn solve(input: []const u8) !u64 {
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

    var cache = std.StringHashMap(u64).init(allocator);
    defer cache.deinit();

    var sum: u64 = 0;

    while (line_iter.next()) |pattern| {
        sum += try possibleCount(pattern, towels.items, &cache);
    }

    return sum;
}

pub fn main() !void {
    const input = @embedFile("input.txt");
    const result = try solve(input);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}\n", .{result});
}

test "test day19b" {
    const input = @embedFile("test_data/day19.txt");
    const result = try solve(input);

    try std.testing.expectEqual(16, result);
}
