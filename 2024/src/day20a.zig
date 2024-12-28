const std = @import("std");

const Point = struct { x: usize, y: usize };

fn solve(input: []const u8, min_saved: u32) !u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    const infinity = std.math.maxInt(u32);

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
                map[x][y] = infinity;

                if (cell == 'S') {
                    start = Point{ .x = x, .y = y };
                    map[x][y] = 0;
                } else if (cell == 'E') {
                    end = Point{ .x = x, .y = y };
                }
            }
        }
    }

    var curr = start;
    var dist: u32 = 0;

    while (!std.meta.eql(curr, end)) : (dist += 1) {
        map[curr.x][curr.y] = dist;

        const neighbors = [4]Point{
            Point{ .x = curr.x + 1, .y = curr.y },
            Point{ .x = curr.x, .y = curr.y + 1 },
            Point{ .x = curr.x -% 1, .y = curr.y },
            Point{ .x = curr.x, .y = curr.y -% 1 },
        };

        for (neighbors) |next| {
            if (map[next.x][next.y] == infinity) {
                curr = next;
                break;
            }
        }
    }

    map[end.x][end.y] = dist;

    var saved: u32 = 0;

    for (0..width) |start_x| {
        for (0..height) |start_y| {
            if (map[start_x][start_y]) |start_dist| {
                const left = @max(start_x, 2) - 2;
                const right = @min(start_x + 2, width - 1);

                const top = @max(start_y, 2) - 2;
                const bottom = @min(start_y + 2, height - 1);

                for (left..right + 1) |end_x| {
                    for (top..bottom + 1) |end_y| {
                        if (map[end_x][end_y]) |end_dist| {
                            const diff_x = if (start_x > end_x) start_x - end_x else end_x - start_x;
                            const diff_y = if (start_y > end_y) start_y - end_y else end_y - start_y;
                            const cheat_dist = diff_x + diff_y;

                            if (cheat_dist <= 2 and
                                end_dist >= min_saved + start_dist + cheat_dist)
                            {
                                saved += 1;
                            }
                        }
                    }
                }
            }
        }
    }

    return saved;
}

pub fn main() !void {
    const input = @embedFile("input.txt");
    const result = try solve(input, 100);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}\n", .{result});
}

test "test day20a" {
    const input = @embedFile("test_data/day20.txt");
    const result = try solve(input, 20);

    try std.testing.expectEqual(5, result);
}
