const std = @import("std");

fn solve(input: []const u8) !u32 {
    var sum: u32 = 0;

    var claw_iter = std.mem.tokenizeSequence(u8, input, "\n\n");
    while (claw_iter.next()) |claw_machine| {
        var nums: [6]f32 = undefined;

        var idx: usize = 0;
        var num_iter = std.mem.tokenizeAny(u8, claw_machine, "Button A:X+,Y\nBPrize=");
        while (num_iter.next()) |num| {
            nums[idx] = try std.fmt.parseFloat(f32, num);
            idx += 1;
        }

        const det = nums[0] * nums[3] - nums[1] * nums[2];
        nums[0] /= det;
        nums[1] /= det;
        nums[2] /= det;
        nums[3] /= det;

        const a_presses = nums[3] * nums[4] - nums[2] * nums[5];
        const b_presses = -nums[1] * nums[4] + nums[0] * nums[5];

        const a_round = @round(a_presses);
        const b_round = @round(b_presses);

        if (@abs(a_presses - a_round) < 0.0001 and @abs(b_presses - b_round) < 0.0001) {
            sum += @intFromFloat(a_round * 3 + b_round);
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

test "test day13a" {
    const input = @embedFile("test_data/day13.txt");
    const result = try solve(input);

    try std.testing.expectEqual(480, result);
}
