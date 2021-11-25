const std = @import("std");
const zdf = @import("./src/zdf/src/main.zig");

const templatesPath = "./gitignore/templates";
const filenameWithoutExtension = zdf.utils.filenameWithoutExtension;

fn countFiles(path: []const u8) !usize {
    var dir = try std.fs.cwd().openDir(path, .{ .iterate = true });
    defer dir.close();

    var walker = try dir.walk(std.heap.page_allocator);
    defer walker.deinit();

    var n: usize = 0;

    while (try walker.next()) |entry| {
        if (std.mem.eql(u8, std.fs.path.extension(entry.path), ".gitignore")) {
            n += 1;
        }
    }

    return n;
}

pub fn build(b: *std.build.Builder) !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("gi", "src/main.zig");
    // b.addUserInputOption
    exe.addPackagePath("zdf", "./src/zdf/src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    var numFiles = try countFiles(templatesPath);

    var dir = try std.fs.cwd().openDir(templatesPath, .{ .iterate = true });
    var walker = try dir.walk(allocator);
    defer walker.deinit();

    // var opts = b.addOptions();
    // opts.addOption()

    // _ = numFiles;
    var files: [][]const u8 = try allocator.alloc([]const u8, numFiles);
    var contents: [][]const u8 = try allocator.alloc([]const u8, numFiles);

    defer allocator.free(files);
    defer allocator.free(contents);

    var i: usize = 0;
    while (try walker.next()) |entry| {
        if (std.mem.eql(u8, std.fs.path.extension(entry.path), ".gitignore")) {
            files[i] = try std.mem.dupe(allocator, u8, filenameWithoutExtension(entry.path));
            var f = try dir.openFile(entry.basename, .{});
            defer f.close();

            var content = try f.readToEndAlloc(allocator, 1024 * 1024 * 1024);
            contents[i] = content;

            i += 1;
        }
    }

    var opts = b.addOptions();
    opts.addOption([]const []const u8, "filenames", files);
    opts.addOption([]const []const u8, "contents", contents);
    exe.addOptions("data", opts);
}
