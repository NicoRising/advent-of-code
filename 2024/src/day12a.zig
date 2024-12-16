const std = @import("std");

const Plot = struct { plant: u8, visited: bool };
const Point = struct { x: usize, y: usize };

fn getNeighbors(map: [][]Plot, point: Point) [4]?Point {
    return [4]?Point{
        if (point.x + 1 < map.len) Point{ .x = point.x + 1, .y = point.y } else null,
        if (point.y + 1 < map[point.x].len) Point{ .x = point.x, .y = point.y + 1 } else null,
        if (point.x > 0) Point{ .x = point.x - 1, .y = point.y } else null,
        if (point.y > 0) Point{ .x = point.x, .y = point.y - 1 } else null,
    };
}

fn calculatePrice(map: [][]Plot, start: Point, allocator: std.mem.Allocator) !u32 {
    const plant = map[start.x][start.y].plant;

    var area: u32 = 0;
    var perimeter: u32 = 0;

    var stack = std.ArrayList(Point).init(allocator);
    defer stack.deinit();

    try stack.append(start);
    while (stack.popOrNull()) |point| {
        const plot = map[point.x][point.y];

        if (plot.plant == plant) {
            if (!plot.visited) {
                map[point.x][point.y].visited = true;

                for (getNeighbors(map, point)) |neighbor| {
                    if (neighbor) |next| {
                        try stack.append(next);
                    } else {
                        perimeter += 1;
                    }
                }

                area += 1;
            }
        } else {
            perimeter += 1;
        }
    }

    return area * perimeter;
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

test "test day12a small" {
    const input = @embedFile("test_data/day12_small.txt");
    const result = try solve(input);

    try std.testing.expectEqual(140, result);
}

test "test day12a medium" {
    const input = @embedFile("test_data/day12_medium.txt");
    const result = try solve(input);

    try std.testing.expectEqual(772, result);
}

test "test day12a large" {
    const input = @embedFile("test_data/day12_large.txt");
    const result = try solve(input);

    try std.testing.expectEqual(1930, result);
}
