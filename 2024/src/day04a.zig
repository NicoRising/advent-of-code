const std = @import("std");

fn get_letter(word_search: []const u8, width: usize, height: usize, x: usize, y: usize) u8 {
    return if (x < width and y < height) word_search[y * width + x] else ' ';
}

fn solve(input: []const u8) !u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    const word_search = try std.mem.replaceOwned(u8, allocator, input, "\n", "");
    defer allocator.free(word_search);

    const length = word_search.len;
    const width = std.mem.indexOf(u8, input, "\n").?;
    const height = @divFloor(length, width);

    var sum: u32 = 0;

    var x: usize = 0;
    while (x < width) : (x += 1) {
        var y: usize = 0;
        while (y < height) : (y += 1) {
            var dirs: [8][4]u8 = undefined;

            var d: usize = 0;
            while (d < 4) : (d += 1) {
                dirs[0][d] = get_letter(word_search, width, height, x, y + d);
                dirs[1][d] = get_letter(word_search, width, height, x, y -% d);
                dirs[2][d] = get_letter(word_search, width, height, x + d, y);
                dirs[3][d] = get_letter(word_search, width, height, x + d, y + d);
                dirs[4][d] = get_letter(word_search, width, height, x + d, y -% d);
                dirs[5][d] = get_letter(word_search, width, height, x -% d, y);
                dirs[6][d] = get_letter(word_search, width, height, x -% d, y + d);
                dirs[7][d] = get_letter(word_search, width, height, x -% d, y -% d);
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
