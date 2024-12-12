const std = @import("std");

fn solvable(result: u64, operands: []u64) !bool {
    if (operands.len == 1) {
        return operands[0] == result;
    }

    const next_operand = operands[operands.len - 1];
    const rest_operands = operands[0 .. operands.len - 1];

    if (result >= next_operand) {
        if (try solvable(result - next_operand, rest_operands) or
            result % next_operand == 0 and try solvable(result / next_operand, rest_operands))
        {
            return true;
        }

        const divisor = std.math.pow(u64, 10, std.math.log10(next_operand) + 1);

        if ((result - next_operand) % divisor == 0) {
            return solvable((result - next_operand) / divisor, rest_operands);
        }
    }

    return false;
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

test "test day07b" {
    const input = @embedFile("test_data/day07.txt");
    const result = try solve(input);

    try std.testing.expectEqual(11387, result);
}
