const std = @import("std");

const Point = struct { x: usize, y: usize };
const Guard = struct { pos: Point, dir: u8 };

fn simulate(
    map: std.ArrayList(std.ArrayList(bool)),
    dims: Point,
    obstacle: ?Point,
    original_guard: Guard,
    allocator: std.mem.Allocator,
) !struct { left: bool, visited: std.AutoHashMap(Guard, void) } {
    if (obstacle != null) {
        map.items[obstacle.?.y].items[obstacle.?.x] = true;
    }
    defer if (obstacle != null) {
        map.items[obstacle.?.y].items[obstacle.?.x] = false;
    };

    var guard = original_guard;
    var visited = std.AutoHashMap(Guard, void).init(allocator);

    var left = false;
    while (!left) {
        if (visited.contains(guard)) {
            break;
        }
        try visited.put(guard, {});

        const next_x, const next_y = switch (guard.dir) {
            0 => .{ guard.pos.x + 1, guard.pos.y },
            1 => .{ guard.pos.x, guard.pos.y + 1 },
            2 => .{ guard.pos.x -% 1, guard.pos.y },
            3 => .{ guard.pos.x, guard.pos.y -% 1 },
            else => unreachable,
        };

        if (next_x < dims.x and next_y < dims.y) {
            if (!map.items[next_y].items[next_x]) {
                guard.pos.x = next_x;
                guard.pos.y = next_y;
            } else {
                guard.dir = (guard.dir + 1) % 4;
            }
        } else {
            left = true;
        }
    }

    return .{ .left = left, .visited = visited };
}

fn solve(input: []const u8) !u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var map = std.ArrayList(std.ArrayList(bool)).init(allocator);
    defer {
        for (map.items) |row| {
            row.deinit();
        }
        map.deinit();
    }

    var guard = Guard{
        .pos = undefined,
        .dir = 3,
    };

    var line_iter = std.mem.tokenizeScalar(u8, input, '\n');
    var row_idx: usize = 0;
    while (line_iter.next()) |line| {
        var row = std.ArrayList(bool).init(allocator);

        for (line, 0..) |char, col_idx| {
            try row.append(char == '#');

            if (char == '^') {
                guard.pos = Point{ .x = col_idx, .y = row_idx };
            }
        }

        try map.append(row);
        row_idx += 1;
    }

    const dims = Point{ .x = map.items.len, .y = map.items[0].items.len };

    var visited = (try simulate(map, dims, null, guard, allocator)).visited;
    defer visited.deinit();

    var candidates = std.AutoHashMap(Point, void).init(allocator);
    defer candidates.deinit();

    var visited_iter = visited.keyIterator();
    while (visited_iter.next()) |state| {
        try candidates.put(state.pos, {});
    }
    _ = candidates.remove(guard.pos);

    var positions: u32 = 0;

    var candidate_iter = candidates.keyIterator();
    while (candidate_iter.next()) |candidate| {
        var result = try simulate(map, dims, candidate.*, guard, allocator);
        result.visited.deinit();

        if (!result.left) {
            positions += 1;
        }
    }

    return positions;
}

pub fn main() !void {
    const input = @embedFile("input.txt");
    const result = try solve(input);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}\n", .{result});
}

test "test day06b" {
    const input = @embedFile("test_data/day06.txt");
    const result = try solve(input);

    try std.testing.expectEqual(6, result);
}
