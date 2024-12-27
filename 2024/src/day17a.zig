const std = @import("std");

const Computer = struct {
    program: []u32,
    pointer: usize,
    reg_a: u32,
    reg_b: u32,
    reg_c: u32,
    output: *std.ArrayList(u32),

    fn literal(self: *Computer) u32 {
        self.pointer += 1;
        return self.program[self.pointer - 1];
    }

    fn combo(self: *Computer) u32 {
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

fn solve(input: []const u8, allocator: std.mem.Allocator) ![]u8 {
    var part_iter = std.mem.tokenizeAny(u8, input, "Register A:\nBCPoam");

    const reg_a = try std.fmt.parseInt(u32, part_iter.next().?, 10);
    const reg_b = try std.fmt.parseInt(u32, part_iter.next().?, 10);
    const reg_c = try std.fmt.parseInt(u32, part_iter.next().?, 10);

    const program_str = part_iter.next().?;

    var program = try allocator.alloc(u32, program_str.len / 2 + 1);
    defer allocator.free(program);

    for (0..program.len) |idx| {
        program[idx] = @intCast(program_str[idx * 2] - 48);
    }

    var output = std.ArrayList(u32).init(allocator);
    defer output.deinit();

    var computer = Computer{
        .program = program,
        .pointer = 0,
        .reg_a = reg_a,
        .reg_b = reg_b,
        .reg_c = reg_c,
        .output = &output,
    };

    while (try computer.tick()) {}

    var output_str = try allocator.alloc(u8, output.items.len * 2 - 1);
    for (0..output_str.len) |idx| {
        if (idx % 2 == 0) {
            output_str[idx] = @intCast(output.items[idx / 2] + 48);
        } else {
            output_str[idx] = ',';
        }
    }

    return output_str;
}

pub fn main() !void {
    const input = @embedFile("input.txt");

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    const result = try solve(input, allocator);
    defer allocator.free(result);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{s}\n", .{result});
}

test "test day17a" {
    const input = @embedFile("test_data/day17a.txt");

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    const result = try solve(input, allocator);
    defer allocator.free(result);

    try std.testing.expectEqualStrings("4,6,3,5,6,3,5,2,1,0", result);
}
