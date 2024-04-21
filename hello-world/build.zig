const std = @import("std");

pub fn build(b: *std.Build) void {
    // Setup target and optimization level
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{
        .default_target = .{
            .cpu_arch = .x86,
            .os_tag = .freestanding,
        },
    });

    // Build operating system
    const saltos = b.addExecutable(.{
        .name = "saltos.elf",
        .root_source_file = b.path("src/init.zig"),
        .target = target,
        .optimize = optimize,
    });
    saltos.setLinkerScript(b.path("linker.ld"));
    b.installArtifact(saltos);

    // Run with QEMU
    const qemu_cmd = b.addSystemCommand(&.{
        "qemu-system-i386",
        "-kernel",
        "zig-out/bin/saltos.elf",
        "-display",
        "gtk,zoom-to-fit=on",
        "-s",
    });
    qemu_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| qemu_cmd.addArgs(args);

    // Run QEMU with zig build run
    const run_step = b.step("run", "Run kernel");
    run_step.dependOn(&qemu_cmd.step);
}
