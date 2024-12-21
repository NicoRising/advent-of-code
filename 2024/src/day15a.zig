const std = @import("std");

const Cell = enum { empty, wall, box, robot };
const Action = enum { right, down, left, up };
const Point = struct { x: usize, y: usize };

fn move(map: [][]Cell, point: Point, action: Action) Point {
    const curr = map[point.x][point.y];
    if (curr == Cell.empty or curr == Cell.wall) {
        return point;
    }

    const next = switch (action) {
        Action.right => Point{ .x = point.x + 1, .y = point.y },
        Action.down => Point{ .x = point.x, .y = point.y + 1 },
        Action.left => Point{ .x = point.x -% 1, .y = point.y },
        Action.up => Point{ .x = point.x, .y = point.y -% 1 },
    };

    _ = move(map, next, action);

    if (map[next.x][next.y] == Cell.empty) {
        map[next.x][next.y] = map[point.x][point.y];
        map[point.x][point.y] = Cell.empty;
        return next;
    }

    return point;
}

fn solve(input: []const u8) !u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var part_iter = std.mem.tokenizeSequence(u8, input, "\n\n");

    const map_input = part_iter.next().?;

    const map_width = std.mem.indexOfScalar(u8, map_input, '\n').?;
    const map_height = map_input.len / map_width;

    const map = try allocator.alloc([]Cell, map_width);
    defer {
        for (map) |col| {
            allocator.free(col);
        }
        allocator.free(map);
    }

    var robot: Point = undefined;

    for (0..map_width) |x| {
        map[x] = try allocator.alloc(Cell, map_height);

        for (0..map_height) |y| {
            const cell = map_input[y * (map_width + 1) + x];

            map[x][y] = switch (cell) {
                '.' => Cell.empty,
                '#' => Cell.wall,
                'O' => Cell.box,
                '@' => Cell.robot,
                else => unreachable,
            };

            if (cell == '@') {
                robot = Point{ .x = x, .y = y };
            }
        }
    }

    for (part_iter.next().?) |char| {
        const action = switch (char) {
            '>' => Action.right,
            'v' => Action.down,
            '<' => Action.left,
            '^' => Action.up,
            else => continue,
        };

        robot = move(map, robot, action);
    }

    var sum: u32 = 0;

    for (0..map_width) |x| {
        for (0..map_height) |y| {
            if (map[x][y] == Cell.box) {
                sum += @intCast(y * 100 + x);
            }
        }
    }

    return sum;
}

pub fn main() !void {
    const input = @embedFile("input.txt");
    const result = try solve(input);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}\n", .{result});
}

test "test day15a small" {
    const input = @embedFile("test_data/day15_small.txt");
    const result = try solve(input);

    try std.testing.expectEqual(2028, result);
}

test "test day15a large" {
    const input = @embedFile("test_data/day15_large.txt");
    const result = try solve(input);

    try std.testing.expectEqual(10092, result);
}
