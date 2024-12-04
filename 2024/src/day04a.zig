const std = @import("std");

fn get_letter(word_search: []const u8, width: i32, height: i32, x: i32, y: i32) u8 {
    return if (x >= 0 and x < width and y >= 0 and y < height) word_search[@intCast(y * width + x)] else ' ';
}

fn solve(input: []const u8) !u32 {
    const word_search = try std.mem.replaceOwned(u8, std.heap.page_allocator, input, "\n", "");

    const length: i32 = @intCast(word_search.len);
    const width: i32 = @intCast(std.mem.indexOf(u8, input, "\n").?);
    const height = @divFloor(length, width);

    var sum: u32 = 0;

    var x: i32 = 0;
    while (x < width) : (x += 1) {
        var y: i32 = 0;
        while (y < height) : (y += 1) {
            var d: i32 = 0;
            var dirs: [8][4]u8 = undefined;

            while (d <= 3) : (d += 1) {
                dirs[0][@intCast(d)] = get_letter(word_search, width, height, x, y + d);
                dirs[1][@intCast(d)] = get_letter(word_search, width, height, x, y - d);
                dirs[2][@intCast(d)] = get_letter(word_search, width, height, x + d, y);
                dirs[3][@intCast(d)] = get_letter(word_search, width, height, x + d, y + d);
                dirs[4][@intCast(d)] = get_letter(word_search, width, height, x + d, y - d);
                dirs[5][@intCast(d)] = get_letter(word_search, width, height, x - d, y);
                dirs[6][@intCast(d)] = get_letter(word_search, width, height, x - d, y + d);
                dirs[7][@intCast(d)] = get_letter(word_search, width, height, x - d, y - d);
            }

            for (dirs) |word| {
                if (std.mem.eql(u8, &word, "XMAS")) {
                    sum += 1;
                }
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

test "test day04" {
    const input = @embedFile("test_data/day04.txt");
    const result = try solve(input);

    try std.testing.expectEqual(18, result);
}
