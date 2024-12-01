const std = @import("std");

const Counts = struct { left_count: u32, right_count: u32 };

fn solve(input: []const u8) !u32 {
    var counts = std.AutoHashMap(u32, Counts).init(std.heap.page_allocator);

    var line_iter = std.mem.tokenizeScalar(u8, input, '\n');
    while (line_iter.next()) |line| {
        var num_iter = std.mem.tokenizeScalar(u8, line, ' ');

        const left = try std.fmt.parseInt(u32, num_iter.next().?, 10);
        const right = try std.fmt.parseInt(u32, num_iter.next().?, 10);

        {
            const count = try counts.getOrPutValue(left, Counts{ .left_count = 0, .right_count = 0 });
            count.value_ptr.left_count += 1;
        }
        {
            const count = try counts.getOrPutValue(right, Counts{ .left_count = 0, .right_count = 0 });
            count.value_ptr.right_count += 1;
        }
    }

    var sum: u32 = 0;
    var counts_iter = counts.iterator();
    while (counts_iter.next()) |count| {
        sum += count.key_ptr.* * count.value_ptr.left_count * count.value_ptr.right_count;
    }

    return sum;
}

pub fn main() !void {
    const input = @embedFile("input.txt");
    const result = try solve(input);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}\n", .{result});
}

test "test day01b" {
    const input = @embedFile("test_data/day01.txt");
    const result = try solve(input);

    try std.testing.expectEqual(31, result);
}
