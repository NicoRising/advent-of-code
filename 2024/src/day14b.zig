const std = @import("std");

const Robot = struct { x: i32, y: i32, dx: i32, dy: i32 };
const Point = struct { x: i32, y: i32 };

fn solve(input: []const u8, width: i32, height: i32) !i32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var robots = std.ArrayList(Robot).init(allocator);
    defer robots.deinit();

    var line_iter = std.mem.tokenizeScalar(u8, input, '\n');
    while (line_iter.next()) |line| {
        var num_iter = std.mem.tokenizeAny(u8, line, "p=, v");
        var nums: [4]i32 = undefined;

        for (0..4) |idx| {
            nums[idx] = try std.fmt.parseInt(i32, num_iter.next().?, 10);
        }

        try robots.append(Robot{ .x = nums[0], .y = nums[1], .dx = nums[2], .dy = nums[3] });
    }

    var locations = std.AutoHashMap(Point, void).init(allocator);
    defer locations.deinit();

    var tick: i32 = 0;
    while (true) : (tick += 1) {
        locations.clearRetainingCapacity();

        robot_loop: for (robots.items) |robot| {
            const x = @mod(robot.x + robot.dx * tick, width);
            const y = @mod(robot.y + robot.dy * tick, height);

            try locations.put(Point{ .x = x, .y = y }, {});

            // There's a tree if there's a 3x3 block of robots, I guess
            var neighbor_x = x - 1;
            while (neighbor_x <= x + 1) : (neighbor_x += 1) {
                var neighbor_y = y - 1;
                while (neighbor_y <= y + 1) : (neighbor_y += 1) {
                    if (!locations.contains(Point{ .x = neighbor_x, .y = neighbor_y })) {
                        continue :robot_loop;
                    }
                }
            }

            return tick;
        }
    }
}

pub fn main() !void {
    const input = @embedFile("input.txt");
    const result = try solve(input, 101, 103);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}\n", .{result});
}
