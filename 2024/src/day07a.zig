const std = @import("std");

fn solvable(result: u64, operands: []u64) !bool {
    if (operands.len == 1) {
        return operands[0] == result;
    }

    const next_operand = operands[operands.len - 1];
    const rest_operands = operands[0 .. operands.len - 1];

    return result >= next_operand and try solvable(result - next_operand, rest_operands) or
        result % next_operand == 0 and try solvable(result / next_operand, rest_operands);
}

fn solve(input: []const u8) !u64 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var sum: u64 = 0;

    var line_iter = std.mem.tokenizeScalar(u8, input, '\n');
    while (line_iter.next()) |line| {
        var num_iter = std.mem.tokenizeAny(u8, line, ": ");

        const result = try std.fmt.parseInt(u64, num_iter.next().?, 10);

        var operands = std.ArrayList(u64).init(allocator);
        defer operands.deinit();

        while (num_iter.next()) |num| {
            try operands.append(try std.fmt.parseInt(u64, num, 10));
        }

        if (try solvable(result, operands.items)) {
            sum += result;
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

test "test day07a" {
    const input = @embedFile("test_data/day07.txt");
    const result = try solve(input);

    try std.testing.expectEqual(3749, result);
}
