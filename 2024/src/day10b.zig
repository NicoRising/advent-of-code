const std = @import("std");

const Cell = struct { height: u8, rating: u32 };

fn getNeighbors(map: [][]Cell, x: usize, y: usize) [4]?Cell {
    return [4]?Cell{
        if (x < map.len - 1) map[x + 1][y] else null,
        if (y < map[x].len - 1) map[x][y + 1] else null,
        if (x > 0) map[x - 1][y] else null,
        if (y > 0) map[x][y - 1] else null,
    };
}

fn updateMap(map: [][]Cell, height: u8) u32 {
    var rating_sum: u32 = 0;

    var x: usize = 0;
    while (x < map.len) : (x += 1) {
        var y: usize = 0;
        while (y < map[x].len) : (y += 1) {
            if (map[x][y].height == height) {
                for (getNeighbors(map, x, y)) |cell| {
                    if (cell) |neighbor| {
                        if (neighbor.height == height - 1) {
                            map[x][y].rating += neighbor.rating;
                            rating_sum += neighbor.rating;
                        }
                    }
                }
            }
        }
    }

    return rating_sum;
}

fn solve(input: []const u8) !u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    const map_width = std.mem.indexOfScalar(u8, input, '\n').?;
    const map_height = input.len / map_width - 1;

    const map = try allocator.alloc([]Cell, map_width);
    defer {
        for (map) |col| {
            allocator.free(col);
        }
        allocator.free(map);
    }

    var x: usize = 0;
    while (x < map_width) : (x += 1) {
        map[x] = try allocator.alloc(Cell, map_height);

        var y: usize = 0;
        while (y < map_height) : (y += 1) {
            const height = input[y * (map_width + 1) + x] - 48;
            const rating: u32 = if (height == 0) 1 else 0;
            map[x][y] = Cell{ .height = height, .rating = rating };
        }
    }

    var trailhead_rating_sum: u32 = 0;

    var height: u8 = 1;
    while (height <= 9) : (height += 1) {
        trailhead_rating_sum = updateMap(map, height);
    }

    return trailhead_rating_sum;
}

pub fn main() !void {
    const input = @embedFile("input.txt");
    const result = try solve(input);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}\n", .{result});
}

test "test day10a" {
    const input = @embedFile("test_data/day10.txt");
    const result = try solve(input);

    try std.testing.expectEqual(81, result);
}
