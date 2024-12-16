const std = @import("std");

const Plot = struct { plant: u8, visited: bool };
const Point = struct { x: usize, y: usize };
const Border = struct { right: bool, bottom: bool, left: bool, top: bool };

fn getNeighbors(map: [][]Plot, point: Point) [4]?Point {
    var neighbors = [4]?Point{
        if (point.x + 1 < map.len) Point{ .x = point.x + 1, .y = point.y } else null,
        if (point.y + 1 < map[point.x].len) Point{ .x = point.x, .y = point.y + 1 } else null,
        if (point.x > 0) Point{ .x = point.x - 1, .y = point.y } else null,
        if (point.y > 0) Point{ .x = point.x, .y = point.y - 1 } else null,
    };

    for (neighbors, 0..) |neighbor, idx| {
        if (neighbor != null and map[neighbor.?.x][neighbor.?.y].plant != map[point.x][point.y].plant) {
            neighbors[idx] = null;
        }
    }

    return neighbors;
}

fn calculatePrice(map: [][]Plot, start: Point, allocator: std.mem.Allocator) !u32 {
    var area: u32 = 0;

    var right_bound = start.x;
    var bottom_bound = start.y;
    var left_bound = start.x;
    var top_bound = start.y;

    var region = std.AutoHashMap(Point, Border).init(allocator);
    defer region.deinit();

    var stack = std.ArrayList(Point).init(allocator);
    defer stack.deinit();

    try stack.append(start);
    while (stack.popOrNull()) |point| {
        if (!region.contains(point)) {
            map[point.x][point.y].visited = true;

            const neighbors = getNeighbors(map, point);

            for (neighbors) |neighbor| {
                if (neighbor) |next| {
                    try stack.append(next);
                }
            }

            const border = Border{
                .right = neighbors[0] == null,
                .bottom = neighbors[1] == null,
                .left = neighbors[2] == null,
                .top = neighbors[3] == null,
            };
            try region.put(point, border);

            if (point.x > right_bound) {
                right_bound = point.x;
            }
            if (point.y > bottom_bound) {
                bottom_bound = point.y;
            }
            if (point.x < left_bound) {
                left_bound = point.x;
            }
            if (point.y < top_bound) {
                top_bound = point.y;
            }

            area += 1;
        }
    }

    var sides: u32 = 0;

    for (left_bound..right_bound + 1) |x| {
        var right_open = false;
        var left_open = false;

        for (top_bound..bottom_bound + 1) |y| {
            const point = Point{ .x = x, .y = y };
            if (region.get(point)) |border| {
                if (!right_open and border.right) {
                    sides += 1;
                }
                if (!left_open and border.left) {
                    sides += 1;
                }
                right_open = border.right;
                left_open = border.left;
            } else {
                right_open = false;
                left_open = false;
            }
        }
    }

    for (top_bound..bottom_bound + 1) |y| {
        var bottom_open = false;
        var top_open = false;

        for (left_bound..right_bound + 1) |x| {
            const point = Point{ .x = x, .y = y };
            if (region.get(point)) |border| {
                if (!bottom_open and border.bottom) {
                    sides += 1;
                }
                if (!top_open and border.top) {
                    sides += 1;
                }

                bottom_open = border.bottom;
                top_open = border.top;
            } else {
                bottom_open = false;
                top_open = false;
            }
        }
    }

    return area * sides;
}

fn solve(input: []const u8) !u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    const width = std.mem.indexOfScalar(u8, input, '\n').?;
    const height = input.len / width - 1;

    const map = try allocator.alloc([]Plot, width);
    defer {
        for (map) |col| {
            allocator.free(col);
        }
        allocator.free(map);
    }

    var x: usize = 0;
    while (x < width) : (x += 1) {
        map[x] = try allocator.alloc(Plot, height);

        var y: usize = 0;
        while (y < height) : (y += 1) {
            map[x][y] = Plot{ .plant = input[y * (width + 1) + x], .visited = false };
        }
    }

    var price: u32 = 0;

    x = 0;
    while (x < width) : (x += 1) {
        var y: usize = 0;
        while (y < height) : (y += 1) {
            if (!map[x][y].visited) {
                price += try calculatePrice(map, Point{ .x = x, .y = y }, allocator);
            }
        }
    }

    return price;
}

pub fn main() !void {
    const input = @embedFile("input.txt");
    const result = try solve(input);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}\n", .{result});
}

test "test day12b small" {
    const input = @embedFile("test_data/day12_small.txt");
    const result = try solve(input);

    try std.testing.expectEqual(80, result);
}

test "test day12b medium" {
    const input = @embedFile("test_data/day12_medium.txt");
    const result = try solve(input);

    try std.testing.expectEqual(436, result);
}

test "test day12b large" {
    const input = @embedFile("test_data/day12_large.txt");
    const result = try solve(input);

    try std.testing.expectEqual(1206, result);
}
