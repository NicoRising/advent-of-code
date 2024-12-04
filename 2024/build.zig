const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const install_step = b.getInstallStep();

    const regex_module = b.dependency("regex", .{
        .target = target,
        .optimize = optimize,
    }).module("regex");

    var day: u32 = 1;
    while (day <= 25) : (day += 1) {
        for ([_]u8{ 'a', 'b' }) |part| {
            const day_str = b.fmt("day{:0>2}{c}", .{ day, part });
            const zig_file = b.fmt("src/{s}.zig", .{day_str});

            const exe_build = b.addExecutable(.{
                .name = day_str,
                .root_source_file = b.path(zig_file),
                .target = target,
                .optimize = optimize,
            });
            exe_build.root_module.addImport("regex", regex_module);

            const run_exe = b.addRunArtifact(exe_build);
            if (b.args) |args| {
                run_exe.addArgs(args);
            }

            const run_desc = b.fmt("Run {s}", .{day_str});

            const run_step = b.step(day_str, run_desc);
            run_step.dependOn(install_step);
            run_step.dependOn(&run_exe.step);

            const test_build = b.addTest(.{
                .root_source_file = b.path(zig_file),
                .target = target,
                .optimize = optimize,
            });
            test_build.root_module.addImport("regex", regex_module);

            const run_test = b.addRunArtifact(test_build);

            const step_key = b.fmt("{s}_test", .{day_str});
            const step_desc = b.fmt("Run {s} tests", .{day_str});

            const test_step = b.step(step_key, step_desc);
            test_step.dependOn(install_step);
            test_step.dependOn(&run_test.step);
        }
    }
}
