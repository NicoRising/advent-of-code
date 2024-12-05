const std = @import("std");
const Regex = @import("regex").Regex;

fn solve(input: []const u8) !i32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var re = try Regex.compile(allocator, "mul\\((\\d+),(\\d+)\\)|(do|don't)\\(\\)");
    defer re.deinit();

    // This regex library currently has issues handling newlines: https://github.com/tiehuis/zig-regex/issues/24
    const fixed_input = try std.mem.replaceOwned(u8, allocator, input, "\n", "");
    defer allocator.free(fixed_input);

    var slice = fixed_input;
    var do = true;
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

        if (std.mem.eql(u8, capture.?.sliceAt(0).?, "do()")) {
            do = true;
        } else if (std.mem.eql(u8, capture.?.sliceAt(0).?, "don't()")) {
            do = false;
        } else if (do) {
            const first = try std.fmt.parseInt(i32, capture.?.sliceAt(1).?, 10);
            const second = try std.fmt.parseInt(i32, capture.?.sliceAt(2).?, 10);
            sum += first * second;
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

test "test day03b" {
    const input = @embedFile("test_data/day03b.txt");
    const result = try solve(input);

    try std.testing.expectEqual(48, result);
}
