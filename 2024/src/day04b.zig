const std = @import("std");

fn get_letter(word_search: []const u8, width: usize, height: usize, x: usize, y: usize) u8 {
    return if (x < width and y < height) word_search[y * width + x] else ' ';
}

fn is_good_word(word: []const u8) bool {
    return std.mem.eql(u8, word, "MAS") or std.mem.eql(u8, word, "SAM");
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

    var x: usize = 1;
    while (x + 1 < width) : (x += 1) {
        var y: usize = 1;
        while (y + 1 < height) : (y += 1) {
            var d: usize = 0;
            var down_right: [3]u8 = undefined;
            var down_left: [3]u8 = undefined;

            while (d < 3) : (d += 1) {
                down_right[d] = get_letter(word_search, width, height, x + d - 1, y + d - 1);
                down_left[d] = get_letter(word_search, width, height, x + d - 1, y -% d +% 1);
            }

            if (is_good_word(&down_right) and is_good_word(&down_left)) {
                sum += 1;
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

    try std.testing.expectEqual(9, result);
}
