const std = @import("std");

const Point = struct { x: usize, y: usize };

fn getNeighbors(map: [][]u8, point: Point) [4]?Point {
    return [4]?Point{
        if (point.x < map.len - 1) Point{ .x = point.x + 1, .y = point.y } else null,
        if (point.y < map[point.x].len - 1) Point{ .x = point.x, .y = point.y + 1 } else null,
        if (point.x > 0) Point{ .x = point.x - 1, .y = point.y } else null,
        if (point.y > 0) Point{ .x = point.x, .y = point.y - 1 } else null,
    };
}

fn reachablePeaks(map: [][]u8, point: Point, peaks: *std.AutoHashMap(Point, void)) !void {
    if (map[point.x][point.y] == 9) {
        try peaks.put(point, {});
    }

    for (getNeighbors(map, point)) |cell| {
        if (cell) |neighbor| {
            if (map[neighbor.x][neighbor.y] == map[point.x][point.y] + 1) {
                try reachablePeaks(map, neighbor, peaks);
            }
        }
    }
}

fn solve(input: []const u8) !u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    const map_width = std.mem.indexOfScalar(u8, input, '\n').?;
    const map_height = input.len / map_width - 1;

    const map = try allocator.alloc([]u8, map_width);
    defer {
        for (map) |col| {
            allocator.free(col);
        }
        allocator.free(map);
    }

    var trailheads = std.ArrayList(Point).init(allocator);
    defer trailheads.deinit();

    var x: usize = 0;
    while (x < map_width) : (x += 1) {
        map[x] = try allocator.alloc(u8, map_height);

        var y: usize = 0;
        while (y < map_height) : (y += 1) {
            const height = input[y * (map_width + 1) + x] - 48;
            map[x][y] = height;

            if (height == 0) {
                try trailheads.append(Point{ .x = x, .y = y });
            }
        }
    }

    var peaks = std.AutoHashMap(Point, void).init(allocator);
    defer peaks.deinit();

    var trailhead_score_sum: u32 = 0;

    for (trailheads.items) |trailhead| {
        try reachablePeaks(map, trailhead, &peaks);
        trailhead_score_sum += peaks.count();
        peaks.clearRetainingCapacity();
    }

    return trailhead_score_sum;
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

    try std.testing.expectEqual(36, result);
}
