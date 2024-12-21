const std = @import("std");

const Cell = enum { empty, wall, left_box, right_box, robot };
const Action = enum { right, down, left, up };
const Point = struct { x: usize, y: usize };

fn move_cells(map: [][]Cell, point: Point, action: Action, points: *std.ArrayList(Point)) !bool {
    const curr = map[point.x][point.y];
    if (curr == Cell.empty) {
        return true;
    } else if (curr == Cell.wall) {
        return false;
    }

    try points.append(point);

    const next = switch (action) {
        Action.right => Point{ .x = point.x + 1, .y = point.y },
        Action.down => Point{ .x = point.x, .y = point.y + 1 },
        Action.left => Point{ .x = point.x -% 1, .y = point.y },
        Action.up => Point{ .x = point.x, .y = point.y -% 1 },
    };

    const can_move = try move_cells(map, next, action, points);

    if (curr == Cell.robot or action == Action.left or action == Action.right) {
        return can_move;
    }

    const adjacent = switch (curr) {
        Cell.left_box => Point{ .x = point.x + 1, .y = point.y },
        Cell.right_box => Point{ .x = point.x - 1, .y = point.y },
        else => unreachable,
    };

    try points.append(adjacent);

    const next_adjacent = switch (curr) {
        Cell.left_box => Point{ .x = next.x + 1, .y = next.y },
        Cell.right_box => Point{ .x = next.x - 1, .y = next.y },
        else => unreachable,
    };

    return can_move and try move_cells(map, next_adjacent, action, points);
}

fn solve(input: []const u8) !u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var part_iter = std.mem.tokenizeSequence(u8, input, "\n\n");

    const map_input = part_iter.next().?;

    const map_width = std.mem.indexOfScalar(u8, map_input, '\n').?;
    const map_height = map_input.len / map_width;

    const map = try allocator.alloc([]Cell, map_width * 2);
    defer {
        for (map) |col| {
            allocator.free(col);
        }
        allocator.free(map);
    }

    var robot: Point = undefined;

    for (0..map_width * 2) |x| {
        map[x] = try allocator.alloc(Cell, map_height);

        for (0..map_height) |y| {
            const cell = map_input[y * (map_width + 1) + x / 2];

            map[x][y] = switch (cell) {
                '.', '@' => Cell.empty,
                '#' => Cell.wall,
                'O' => if (x % 2 == 0) Cell.left_box else Cell.right_box,
                else => unreachable,
            };

            if (cell == '@' and x % 2 == 0) {
                map[x][y] = Cell.robot;
                robot = Point{ .x = x, .y = y };
            }
        }
    }

    var points = std.ArrayList(Point).init(allocator);
    defer points.deinit();

    var visited = std.AutoHashMap(Point, void).init(allocator);
    defer visited.deinit();

    for (part_iter.next().?) |char| {
        const action = switch (char) {
            '>' => Action.right,
            'v' => Action.down,
            '<' => Action.left,
            '^' => Action.up,
            else => continue,
        };

        if (try move_cells(map, robot, action, &points)) {
            while (points.popOrNull()) |point| {
                if (!visited.contains(point)) {
                    try visited.put(point, {});

                    const next = switch (action) {
                        Action.right => Point{ .x = point.x + 1, .y = point.y },
                        Action.down => Point{ .x = point.x, .y = point.y + 1 },
                        Action.left => Point{ .x = point.x - 1, .y = point.y },
                        Action.up => Point{ .x = point.x, .y = point.y - 1 },
                    };

                    if (map[point.x][point.y] == Cell.robot) {
                        robot = next;
                    }

                    map[next.x][next.y] = map[point.x][point.y];
                    map[point.x][point.y] = Cell.empty;
                }
            }
        }

        points.clearRetainingCapacity();
        visited.clearRetainingCapacity();
    }

    var sum: u32 = 0;

    for (0..map_width * 2) |x| {
        for (0..map_height) |y| {
            if (map[x][y] == Cell.left_box) {
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

test "test day15a large" {
    const input = @embedFile("test_data/day15_large.txt");
    const result = try solve(input);

    try std.testing.expectEqual(9021, result);
}
