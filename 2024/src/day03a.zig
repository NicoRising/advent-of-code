const std = @import("std");
const Regex = @import("regex").Regex;

fn parseInt(str: []const u8) !i32 {
    return try std.fmt.parseInt(i32, str, 10);
}

fn solve(input: []const u8) !i32 {
    var re = try Regex.compile(std.heap.page_allocator, "mul\\((\\d+),(\\d+)\\)");

    // This regex library currently has issues handling newlines: https://github.com/tiehuis/zig-regex/issues/24
    var slice = try std.mem.replaceOwned(u8, std.heap.page_allocator, input, "\n", "");

    var capture = try re.captures(slice);
    var sum: i32 = 0;

    while (capture != null) : (capture = try re.captures(slice)) {
        slice = slice[capture.?.boundsAt(0).?.upper..];

        const first = try parseInt(capture.?.sliceAt(1).?);
        const second = try parseInt(capture.?.sliceAt(2).?);
        sum += first * second;
    }

    return sum;
}

pub fn main() !void {
    const input = @embedFile("input.txt");
    const result = try solve(input);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}\n", .{result});
}

test "test day03a" {
    const input = @embedFile("test_data/day03a.txt");
    const result = try solve(input);

    try std.testing.expectEqual(161, result);
}
