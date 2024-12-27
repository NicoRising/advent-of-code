const std = @import("std");

const Point = struct { x: usize, y: usize };
const Cell = struct { g_score: u32, f_score: u32 };

fn lessThan(map: [][]?Cell, a: Point, b: Point) std.math.Order {
    return std.math.order(map[a.x][a.y].?.f_score, map[b.x][b.y].?.f_score);
}

fn solve(input: []const u8, width: usize, bytes: usize) !u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var map = try allocator.alloc([]?Cell, width);
    for (0..width) |x| {
        map[x] = try allocator.alloc(?Cell, width);

        const infinity = std.math.maxInt(u32);
        @memset(map[x], Cell{ .g_score = infinity, .f_score = infinity });
    }
    defer {
        for (map) |col| {
            allocator.free(col);
        }
        allocator.free(map);
    }

    var line_iter = std.mem.tokenizeScalar(u8, input, '\n');
    var byte: usize = 0;
    while (line_iter.next()) |line| {
        if (byte >= bytes) {
            break;
        }
        byte += 1;

        var num_iter = std.mem.tokenizeScalar(u8, line, ',');

        const x = try std.fmt.parseInt(usize, num_iter.next().?, 10);
        const y = try std.fmt.parseInt(usize, num_iter.next().?, 10);

        map[x][y] = null;
    }

    map[0][0].?.g_score = 0;
    map[0][0].?.f_score = @intCast(2 * width - 2);

    var steps: u32 = undefined;

    var open_set = std.PriorityQueue(Point, [][]?Cell, lessThan).init(allocator, map);
    defer open_set.deinit();

    try open_set.add(Point{ .x = 0, .y = 0 });

    while (open_set.removeOrNull()) |curr| {
        if (curr.x == width - 1 and curr.y == width - 1) {
            steps = map[curr.x][curr.y].?.g_score;
            break;
        }

        const neighbors = [4]Point{
            Point{ .x = curr.x + 1, .y = curr.y },
            Point{ .x = curr.x, .y = curr.y + 1 },
            Point{ .x = curr.x -% 1, .y = curr.y },
            Point{ .x = curr.x, .y = curr.y -% 1 },
        };

        for (neighbors) |next| {
            if (next.x < width and next.y < width) {
                if (map[next.x][next.y]) |next_cell| {
                    const next_g_score = map[curr.x][curr.y].?.g_score + 1;
                    if (next_g_score < next_cell.g_score) {
                        map[next.x][next.y].?.g_score = next_g_score;

                        const heuristic: u32 = @intCast(2 * width - next.x - next.y - 2);
                        map[next.x][next.y].?.f_score = next_g_score + heuristic;

                        try open_set.add(next);
                    }
                }
            }
        }
    }

    return steps;
}

pub fn main() !void {
    const input = @embedFile("input.txt");
    const result = try solve(input, 71, 1024);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}\n", .{result});
}

test "test day18a" {
    const input = @embedFile("test_data/day18.txt");
    const result = try solve(input, 7, 12);

    try std.testing.expectEqual(22, result);
}
