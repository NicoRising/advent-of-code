const std = @import("std");

fn lessThan(rules: std.AutoHashMap(u32, std.AutoHashMap(u32, void)), lhs: u32, rhs: u32) bool {
    if (rules.get(lhs)) |children| {
        return children.contains(rhs);
    } else return false;
}

fn solve(input: []const u8) !u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var rules = std.AutoHashMap(u32, std.AutoHashMap(u32, void)).init(allocator);
    defer {
        var value_iter = rules.valueIterator();
        while (value_iter.next()) |children| {
            children.deinit();
        }
        rules.deinit();
    }

    var section_iter = std.mem.tokenizeSequence(u8, input, "\n\n");

    var rule_iter = std.mem.tokenizeScalar(u8, section_iter.next().?, '\n');
    while (rule_iter.next()) |rule| {
        var page_iter = std.mem.tokenizeScalar(u8, rule, '|');
        const parent = try std.fmt.parseInt(u32, page_iter.next().?, 10);
        const child = try std.fmt.parseInt(u32, page_iter.next().?, 10);

        var children = try rules.getOrPutValue(parent, std.AutoHashMap(u32, void).init(allocator));
        try children.value_ptr.put(child, {});
    }

    var sum: u32 = 0;

    var update_iter = std.mem.tokenizeScalar(u8, section_iter.next().?, '\n');
    while (update_iter.next()) |line| {
        var update = std.ArrayList(u32).init(allocator);
        defer update.deinit();

        var page_iter = std.mem.tokenizeScalar(u8, line, ',');
        while (page_iter.next()) |page| {
            try update.append(try std.fmt.parseInt(u32, page, 10));
        }

        if (std.sort.isSorted(u32, update.items, rules, lessThan)) {
            sum += update.items[(update.items.len - 1) / 2];
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

test "test day05a" {
    const input = @embedFile("test_data/day05.txt");
    const result = try solve(input);

    try std.testing.expectEqual(143, result);
}
