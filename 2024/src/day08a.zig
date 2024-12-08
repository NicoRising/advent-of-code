const std = @import("std");

const Point = struct { x: i32, y: i32 };

fn solve(input: []const u8) !u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var antennas = std.AutoHashMap(u8, std.ArrayList(Point)).init(allocator);
    defer {
        var locations_iter = antennas.valueIterator();
        while (locations_iter.next()) |locations| {
            locations.deinit();
        }
        antennas.deinit();
    }

    var y: i32 = 0;
    var x: i32 = 0;

    var line_iter = std.mem.tokenizeScalar(u8, input, '\n');
    while (line_iter.next()) |line| {
        x = 0;
        for (line) |char| {
            if (char != '.') {
                var locations = try antennas.getOrPutValue(char, std.ArrayList(Point).init(allocator));
                try locations.value_ptr.append(Point{ .x = x, .y = y });
            }
            x += 1;
        }
        y += 1;
    }

    const width = x;
    const height = y;

    var antinodes = std.AutoHashMap(Point, void).init(allocator);
    defer antinodes.deinit();

    var locations_iter = antennas.valueIterator();
    while (locations_iter.next()) |locations| {
        var first_idx: usize = 0;
        while (first_idx < locations.items.len) : (first_idx += 1) {
            var second_idx: usize = 0;
            while (second_idx < locations.items.len) : (second_idx += 1) {
                if (first_idx != second_idx) {
                    const first = locations.items[first_idx];
                    const second = locations.items[second_idx];

                    const antinode = Point{ .x = second.x * 2 - first.x, .y = second.y * 2 - first.y };

                    if (antinode.x >= 0 and antinode.y >= 0 and antinode.x < width and antinode.y < height) {
                        try antinodes.put(antinode, {});
                    }
                }
            }
        }
    }

    return antinodes.count();
}

pub fn main() !void {
    const input = @embedFile("input.txt");
    const result = try solve(input);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}\n", .{result});
}

test "test day08a" {
    const input = @embedFile("test_data/day08.txt");
    const result = try solve(input);

    try std.testing.expectEqual(14, result);
}
