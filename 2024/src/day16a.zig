const std = @import("std");

const Point = struct { x: usize, y: usize };

fn lessThan(map: [][]?u32, a: Point, b: Point) std.math.Order {
    var order = std.math.order(map[a.x][a.y].?, map[b.x][b.y].?);
    if (order != .eq) {
        return order;
    }

    order = std.math.order(a.x, b.x);
    if (order != .eq) {
        return order;
    }

    return std.math.order(a.y, b.y);
}

fn solve(input: []const u8) !u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    const width = std.mem.indexOfScalar(u8, input, '\n').?;
    const height = input.len / width - 1;

    const map = try allocator.alloc([]?u32, width);
    defer {
        for (map) |col| {
            allocator.free(col);
        }
        allocator.free(map);
    }

    var start: Point = undefined;
    var end: Point = undefined;

    for (0..width) |x| {
        map[x] = try allocator.alloc(?u32, height);

        for (0..height) |y| {
            const cell = input[y * (width + 1) + x];

            if (cell == '#') {
                map[x][y] = null;
            } else {
                map[x][y] = std.math.maxInt(u32);

                if (cell == 'S') {
                    start = Point{ .x = x, .y = y };
                    map[x][y] = 0;
                } else if (cell == 'E') {
                    end = Point{ .x = x, .y = y };
                }
            }
        }
    }

    var queue = std.PriorityQueue(Point, [][]?u32, lessThan).init(allocator, map);
    defer queue.deinit();

    var prev_map = std.AutoHashMap(Point, Point).init(allocator);
    defer prev_map.deinit();

    try queue.add(start);

    try prev_map.put(start, Point{ .x = start.x - 1, .y = start.y });

    while (queue.removeOrNull()) |curr| {
        const neighbors = [4]Point{
            Point{ .x = curr.x + 1, .y = curr.y },
            Point{ .x = curr.x, .y = curr.y + 1 },
            Point{ .x = curr.x - 1, .y = curr.y },
            Point{ .x = curr.x, .y = curr.y - 1 },
        };

        for (neighbors) |next| {
            if (map[next.x][next.y]) |next_cost| {
                const prev = prev_map.get(curr).?;
                const cost: u32 = if (prev.x == next.x or prev.y == next.y) 1 else 1001;

                const alt = map[curr.x][curr.y].? + cost;
                if (alt < next_cost) {
                    map[next.x][next.y] = alt;
                    try queue.add(next);
                    try prev_map.put(next, curr);
                }
            }
        }
    }

    return map[end.x][end.y].?;
}

pub fn main() !void {
    const input = @embedFile("input.txt");
    const result = try solve(input);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}\n", .{result});
}

test "test day16a small" {
    const input = @embedFile("test_data/day16_small.txt");
    const result = try solve(input);

    try std.testing.expectEqual(7036, result);
}

test "test day16a large" {
    const input = @embedFile("test_data/day16_large.txt");
    const result = try solve(input);

    try std.testing.expectEqual(11048, result);
}
