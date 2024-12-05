const std = @import("std");
const regex = @import("regex");

fn solve(input: []const u8) !i32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var re = try regex.Regex.compile(allocator, "mul\\((\\d+),(\\d+)\\)");
    defer re.deinit();

    // This regex library currently has issues handling newlines: https://github.com/tiehuis/zig-regex/issues/24
    const fixed_input = try std.mem.replaceOwned(u8, allocator, input, "\n", "");
    defer allocator.free(fixed_input);

    var slice = fixed_input;
    var sum: i32 = 0;

    var done = false;
    while (!done) {
        var capture = try re.captures(slice);
        if (capture == null) {
            done = true;
            break;
        }
        defer capture.?.deinit();

        slice = slice[capture.?.boundsAt(0).?.upper..];

        const first = try std.fmt.parseInt(i32, capture.?.sliceAt(1).?, 10);
        const second = try std.fmt.parseInt(i32, capture.?.sliceAt(2).?, 10);
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
