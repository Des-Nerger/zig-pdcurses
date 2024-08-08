const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "zig-pdcurses",
        .target = target,
        .optimize = optimize,
    });
    const pdcurses = b.dependency("pdcurses_git", .{});
    lib.addCSourceFiles(.{
        .root = pdcurses.path(""),
        .files = &[_][]const u8{
            "pdcurses/addch.c",
            "pdcurses/addchstr.c",
            "pdcurses/addstr.c",
            "pdcurses/attr.c",
            "pdcurses/beep.c",
            "pdcurses/bkgd.c",
            "pdcurses/border.c",
            "pdcurses/clear.c",
            "pdcurses/color.c",
            "pdcurses/debug.c",
            "pdcurses/delch.c",
            "pdcurses/deleteln.c",
            "pdcurses/getch.c",
            "pdcurses/getstr.c",
            "pdcurses/getyx.c",
            "pdcurses/inch.c",
            "pdcurses/inchstr.c",
            "pdcurses/initscr.c",
            "pdcurses/inopts.c",
            "pdcurses/insch.c",
            "pdcurses/insstr.c",
            "pdcurses/instr.c",
            "pdcurses/kernel.c",
            "pdcurses/keyname.c",
            "pdcurses/mouse.c",
            "pdcurses/move.c",
            "pdcurses/outopts.c",
            "pdcurses/overlay.c",
            "pdcurses/pad.c",
            "pdcurses/panel.c",
            "pdcurses/printw.c",
            "pdcurses/refresh.c",
            "pdcurses/scanw.c",
            "pdcurses/scroll.c",
            "pdcurses/scr_dump.c",
            "pdcurses/slk.c",
            "pdcurses/termattr.c",
            "pdcurses/touch.c",
            "pdcurses/util.c",
            "pdcurses/window.c",
            "wincon/pdcclip.c",
            "wincon/pdcdisp.c",
            "wincon/pdcgetsc.c",
            "wincon/pdckbd.c",
            "wincon/pdcscrn.c",
            "wincon/pdcsetsc.c",
            "wincon/pdcutil.c",
        },
        .flags = &[_][]const u8{"-Wno-date-time"}, // otherwise build stops due to warning about __DATE__ usage, which i can't do anything about
    });

    lib.addIncludePath(pdcurses.path(""));
    lib.addIncludePath(pdcurses.path("common"));
    lib.addIncludePath(pdcurses.path("pdcurses"));
    lib.linkLibC();
    lib.installHeader(pdcurses.path("curses.h"), "curses.h");
    // This declares intent for the library to be installed into the standard
    // location when the user invokes the "install" step (the default step when
    // running `zig build`).
    b.installArtifact(lib);
}
