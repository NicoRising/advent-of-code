const std = @import("std");

const CellState = enum { empty, visited, blocked };

fn solve(input: []const u8) !u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var map = std.ArrayList(std.ArrayList(CellState)).init(allocator);
    defer {
        for (map.items) |row| {
            row.deinit();
        }
        map.deinit();
    }

    var guard_x: usize = undefined;
    var guard_y: usize = undefined;
    var guard_dir: u8 = 3;

    var line_iter = std.mem.tokenizeScalar(u8, input, '\n');
    var y: u32 = 0;
    while (line_iter.next()) |line| {
        var row = std.ArrayList(CellState).init(allocator);

        for (line, 0..) |char, x| {
            try row.append(if (char == '#') CellState.blocked else CellState.empty);

            if (char == '^') {
                guard_x = x;
                guard_y = y;
            }
        }

        try map.append(row);
        y += 1;
    }

    const width = map.items.len;
    const height = map.items[0].items.len;
    var visited: u32 = 0;

    var done = false;
    while (!done) {
        if (map.items[guard_y].items[guard_x] == .empty) {
            map.items[guard_y].items[guard_x] = .visited;
            visited += 1;
        }

        const next_x, const next_y = switch (guard_dir) {
            0 => .{ guard_x + 1, guard_y },
            1 => .{ guard_x, guard_y + 1 },
            2 => .{ guard_x -% 1, guard_y },
            3 => .{ guard_x, guard_y -% 1 },
            else => unreachable,
        };

        if (next_x < width and next_y < height) {
            if (map.items[next_y].items[next_x] != .blocked) {
                guard_x = next_x;
                guard_y = next_y;
            } else {
                guard_dir = (guard_dir + 1) % 4;
            }
        } else {
            done = true;
        }
    }

    return visited;
}

pub fn main() !void {
    const input = @embedFile("input.txt");
    const result = try solve(input);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}\n", .{result});
}

test "test day06a" {
    const input = @embedFile("test_data/day06.txt");
    const result = try solve(input);

    try std.testing.expectEqual(41, result);
}
