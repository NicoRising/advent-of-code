const std = @import("std");

fn lessThan(context: void, a: u32, b: u32) std.math.Order {
    _ = context;
    return std.math.order(a, b);
}

fn solve(input: []const u8) !u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var left_queue = std.PriorityQueue(u32, void, lessThan).init(allocator, {});
    defer left_queue.deinit();

    var right_queue = std.PriorityQueue(u32, void, lessThan).init(allocator, {});
    defer right_queue.deinit();

    var line_iter = std.mem.tokenizeScalar(u8, input, '\n');
    while (line_iter.next()) |line| {
        var num_iter = std.mem.tokenizeScalar(u8, line, ' ');

        const left = try std.fmt.parseInt(u32, num_iter.next().?, 10);
        const right = try std.fmt.parseInt(u32, num_iter.next().?, 10);

        try left_queue.add(left);
        try right_queue.add(right);
    }

    var sum: u32 = 0;
    while (left_queue.count() > 0 and right_queue.count() > 0) {
        const left = left_queue.remove();
        const right = right_queue.remove();
        sum += if (left >= right) left - right else right - left;
    }

    return sum;
}

pub fn main() !void {
    const input = @embedFile("input.txt");
    const result = try solve(input);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}\n", .{result});
}

test "test day01a" {
    const input = @embedFile("test_data/day01.txt");
    const result = try solve(input);

    try std.testing.expectEqual(11, result);
}
