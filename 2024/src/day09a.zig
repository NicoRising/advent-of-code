const std = @import("std");

fn solve(input: []const u8) !u64 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var disk = std.ArrayList(?u32).init(allocator);
    defer disk.deinit();

    var id: u32 = 0;
    var is_file = true;
    for (input[0 .. input.len - 1]) |char| {
        const length = char - 48;

        if (is_file) {
            try disk.appendNTimes(id, length);
            id += 1;
        } else {
            try disk.appendNTimes(null, length);
        }

        is_file = !is_file;
    }

    var checksum: u64 = 0;

    var block: usize = 0;
    while (block < disk.items.len) : (block += 1) {
        var block_id = disk.items[block];

        while (block_id == null and block < disk.items.len) {
            block_id = disk.pop();
        }

        if (block_id) |file_id| {
            checksum += file_id * block;
        }
    }

    return checksum;
}

pub fn main() !void {
    const input = @embedFile("input.txt");
    const result = try solve(input);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}\n", .{result});
}

test "test day09a" {
    const input = @embedFile("test_data/day09.txt");
    const result = try solve(input);

    try std.testing.expectEqual(1928, result);
}
