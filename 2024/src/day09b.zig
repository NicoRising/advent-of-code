const std = @import("std");

const Chunk = struct { length: u8, id: ?u32 };

fn solve(input: []const u8) !u64 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var disk_map = std.ArrayList(Chunk).init(allocator);
    defer disk_map.deinit();

    for (input[0 .. input.len - 1], 0..) |char, idx| {
        const id: ?u32 = if (idx % 2 == 0) @intCast(idx / 2) else null;
        try disk_map.append(Chunk{ .length = char - 48, .id = id });
    }

    var end_idx: usize = disk_map.items.len - 1;
    while (end_idx > 0) : (end_idx -= 1) {
        const end = disk_map.items[end_idx];
        if (end.id != null) {
            for (disk_map.items, 0..) |start, start_idx| {
                if (start.id == null and start_idx < end_idx and start.length >= end.length) {
                    disk_map.items[end_idx] = Chunk{ .length = end.length, .id = null };

                    const free_chunk = Chunk{ .length = start.length - end.length, .id = null };
                    try disk_map.replaceRange(start_idx, 1, &[_]Chunk{ end, free_chunk });

                    end_idx += 1;
                    break;
                }
            }
        }
    }

    var checksum: u64 = 0;

    var pos: u32 = 0;
    for (disk_map.items) |chunk| {
        if (chunk.id) |id| {
            checksum += chunk.length * (2 * pos + chunk.length - 1) / 2 * id;
        }

        pos += chunk.length;
    }

    return checksum;
}

pub fn main() !void {
    const input = @embedFile("input.txt");
    const result = try solve(input);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}\n", .{result});
}

test "test day09b" {
    const input = @embedFile("test_data/day09.txt");
    const result = try solve(input);

    try std.testing.expectEqual(2858, result);
}
