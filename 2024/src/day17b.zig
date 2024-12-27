const std = @import("std");

const Node = struct { start: u64, end: u64, correct: usize };

const Computer = struct {
    program: []u64,
    pointer: usize,
    reg_a: u64,
    reg_b: u64,
    reg_c: u64,
    output: *std.ArrayList(u64),

    fn literal(self: *Computer) u64 {
        self.pointer += 1;
        return self.program[self.pointer - 1];
    }

    fn combo(self: *Computer) u64 {
        self.pointer += 1;
        return switch (self.program[self.pointer - 1]) {
            0 => 0,
            1 => 1,
            2 => 2,
            3 => 3,
            4 => self.reg_a,
            5 => self.reg_b,
            6 => self.reg_c,
            else => unreachable,
        };
    }

    fn adv(self: *Computer) !void {
        self.reg_a = self.reg_a >> @intCast(self.combo());
    }

    fn bxl(self: *Computer) void {
        self.reg_b = self.reg_b ^ self.literal();
    }

    fn bst(self: *Computer) void {
        self.reg_b = self.combo() & 7;
    }

    fn jnz(self: *Computer) void {
        if (self.reg_a != 0) {
            self.pointer = self.literal();
        }
    }

    fn bxc(self: *Computer) void {
        self.reg_b = self.reg_b ^ self.reg_c;
        self.pointer += 1;
    }

    fn out(self: *Computer) !void {
        try self.output.append(self.combo() & 7);
    }

    fn bdv(self: *Computer) !void {
        self.reg_b = self.reg_a >> @intCast(self.combo());
    }

    fn cdv(self: *Computer) !void {
        self.reg_c = self.reg_a >> @intCast(self.combo());
    }

    fn tick(self: *Computer) !bool {
        if (self.pointer + 1 >= self.program.len) {
            return false;
        }

        try switch (self.literal()) {
            0 => self.adv(),
            1 => self.bxl(),
            2 => self.bst(),
            3 => self.jnz(),
            4 => self.bxc(),
            5 => self.out(),
            6 => self.bdv(),
            7 => self.cdv(),
            else => unreachable,
        };

        return true;
    }
};

fn solve(input: []const u8) !u64 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var part_iter = std.mem.tokenizeAny(u8, input, "Register A:\nBCPoam");
    _ = part_iter.next();

    const reg_b = try std.fmt.parseInt(u64, part_iter.next().?, 10);
    const reg_c = try std.fmt.parseInt(u64, part_iter.next().?, 10);

    const program_str = part_iter.next().?;

    var program = try allocator.alloc(u64, program_str.len / 2 + 1);
    defer allocator.free(program);

    for (0..program.len) |idx| {
        program[idx] = @intCast(program_str[idx * 2] - 48);
    }

    var output = std.ArrayList(u64).init(allocator);
    defer output.deinit();

    var queue = std.ArrayList(Node).init(allocator);
    defer queue.deinit();

    try queue.append(Node{
        .start = try std.math.powi(u64, 8, program.len - 1),
        .end = try std.math.powi(u64, 8, program.len),
        .correct = 0,
    });

    // Very evil
    var reg_a: u64 = undefined;
    var idx: usize = 0;
    while (idx < queue.items.len) : (idx += 1) {
        const node = queue.items[idx];
        reg_a = node.start;

        if (node.correct == program.len) {
            return node.start;
        }

        var start: ?u64 = null;
        var correct: usize = 0;

        var shift = (node.end - node.start) >> 10;
        if (shift == 0) {
            shift = 1;
        }

        while (reg_a < node.end) : (reg_a += shift) {
            var computer = Computer{
                .program = program,
                .pointer = 0,
                .reg_a = reg_a,
                .reg_b = reg_b,
                .reg_c = reg_c,
                .output = &output,
            };

            while (try computer.tick()) {}

            var curr_correct: usize = 0;
            while (curr_correct < program.len) : (curr_correct += 1) {
                const comp_idx = program.len - curr_correct - 1;
                if (output.items[comp_idx] != program[comp_idx]) {
                    break;
                }
            }

            if (curr_correct > node.correct) {
                if (start == null) {
                    start = reg_a;
                    correct = curr_correct;
                }
            } else {
                if (start) |min| {
                    try queue.append(Node{
                        .start = min,
                        .end = reg_a,
                        .correct = correct,
                    });
                }

                start = null;
            }

            output.clearRetainingCapacity();
        }

        if (start) |min| {
            try queue.append(Node{
                .start = min,
                .end = node.end,
                .correct = correct,
            });
        }
    }

    return reg_a;
}

pub fn main() !void {
    const input = @embedFile("input.txt");
    const result = try solve(input);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}\n", .{result});
}

test "test day17b" {
    const input = @embedFile("test_data/day17b.txt");
    const result = try solve(input);

    try std.testing.expectEqual(117440, result);
}
