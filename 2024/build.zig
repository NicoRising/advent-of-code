const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardOptimizeOption(.{});

    var day: u32 = 1;
    while (day <= 25) : (day += 1) {
        for ([_]u8{ 'a', 'b' }) |part| {
            const day_str = b.fmt("day{:0>2}{c}", .{ day, part });
            const zig_file = b.fmt("src/{s}.zig", .{day_str});

            const exe = b.addExecutable(.{
                .name = day_str,
                .root_source_file = b.path(zig_file),
                .target = target,
                .optimize = mode,
            });

            const run_cmd = b.addRunArtifact(exe);
            if (b.args) |args| {
                run_cmd.addArgs(args);
            }

            const run_desc = b.fmt("Run {s}", .{day_str});
            const run_step = b.step(day_str, run_desc);
            run_step.dependOn(&run_cmd.step);

            const build_test = b.addTest(.{
                .root_source_file = b.path(zig_file),
                .target = target,
                .optimize = mode,
            });

            const run_test = b.addRunArtifact(build_test);

            const step_key = b.fmt("{s}_test", .{day_str});
            const step_desc = b.fmt("Run {s} tests", .{day_str});
            const step = b.step(step_key, step_desc);
            step.dependOn(&run_test.step);
        }
    }
}
