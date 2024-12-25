const std = @import("std");

const Point = struct { x: usize, y: usize };
const Node = struct { path: std.ArrayList(Point), cost: u32 };

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

fn getNeighbors(point: Point) [4]Point {
    return [4]Point{
        Point{ .x = point.x + 1, .y = point.y },
        Point{ .x = point.x, .y = point.y + 1 },
        Point{ .x = point.x - 1, .y = point.y },
        Point{ .x = point.x, .y = point.y - 1 },
    };
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
        for (getNeighbors(curr)) |next| {
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

    const best_cost = map[end.x][end.y].?;

    // A little jank, but gets the job done

    var points = std.AutoHashMap(Point, void).init(allocator);
    defer points.deinit();

    var stack = std.ArrayList(Node).init(allocator);
    defer stack.deinit();

    var start_node = std.ArrayList(Point).init(allocator);
    try start_node.append(end);
    try stack.append(Node{ .path = start_node, .cost = 0 });

    while (stack.popOrNull()) |node| {
        defer node.path.deinit();
        if (node.cost <= best_cost) {
            const curr = node.path.getLast();
            const prev = switch (node.path.items.len > 1) {
                true => node.path.items[node.path.items.len - 2],
                false => curr,
            };

            if (std.meta.eql(curr, start) and
                (prev.y == start.y and node.cost == best_cost or
                prev.y != start.y and node.cost + 1000 == best_cost))
            {
                for (node.path.items) |point| {
                    try points.put(point, {});
                }
            } else {
                const curr_cost = map[curr.x][curr.y].?;

                for (getNeighbors(curr)) |next| {
                    if (map[next.x][next.y]) |next_cost| {
                        if (curr_cost >= next_cost and (curr_cost - next_cost == 1 or curr_cost - next_cost == 1001) or
                            curr_cost < next_cost and next_cost - curr_cost == 999)
                        {
                            var next_path = try node.path.clone();
                            try next_path.append(next);

                            const cost: u32 = if (prev.x == next.x or prev.y == next.y) 1 else 1001;

                            try stack.append(Node{ .path = next_path, .cost = node.cost + cost });
                        }
                    }
                }
            }
        }
    }

    return points.count();
}

pub fn main() !void {
    const input = @embedFile("input.txt");
    const result = try solve(input);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}\n", .{result});
}

test "test day16b small" {
    const input = @embedFile("test_data/day16_small.txt");
    const result = try solve(input);

    try std.testing.expectEqual(45, result);
}

test "test day16b large" {
    const input = @embedFile("test_data/day16_large.txt");
    const result = try solve(input);

    try std.testing.expectEqual(64, result);
}
