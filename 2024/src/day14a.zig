const std = @import("std");

fn solve(input: []const u8, width: i32, height: i32) !u32 {
    var upper_left: u32 = 0;
    var lower_left: u32 = 0;
    var upper_right: u32 = 0;
    var lower_right: u32 = 0;

    var line_iter = std.mem.tokenizeScalar(u8, input, '\n');
    while (line_iter.next()) |line| {
        var num_iter = std.mem.tokenizeAny(u8, line, "p=, v");
        var nums: [4]i32 = undefined;

        for (0..4) |idx| {
            nums[idx] = try std.fmt.parseInt(i32, num_iter.next().?, 10);
        }

        const x = @mod(nums[0] + nums[2] * 100, width);
        const y = @mod(nums[1] + nums[3] * 100, height);

        if (x < @divTrunc(width, 2)) {
            if (y < @divTrunc(height, 2)) {
                upper_left += 1;
            } else if (y > @divTrunc(height, 2)) {
                lower_left += 1;
            }
        } else if (x > @divTrunc(width, 2)) {
            if (y < @divTrunc(height, 2)) {
                upper_right += 1;
            } else if (y > @divTrunc(height, 2)) {
                lower_right += 1;
            }
        }
    }

    return upper_left * upper_right * lower_left * lower_right;
}

pub fn main() !void {
    const input = @embedFile("input.txt");
    const result = try solve(input, 101, 103);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}\n", .{result});
}

test "test day14a" {
    const input = @embedFile("test_data/day14.txt");
    const result = try solve(input, 11, 7);

    try std.testing.expectEqual(12, result);
}
