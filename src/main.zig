const std = @import("std");
const zdf = @import("zdf");
const data = @import("data");

const stdout = std.io.getStdOut().writer();

fn usage() !void {
    try stdout.writeAll("Usage: gi [-l, --list] [<template_name>...]\n");
}

fn printAvailable() !void {
    const templateNames = data.filenames;

    try stdout.writeAll("Available templates:\n");
    for (templateNames) |name| {
        try stdout.print("\t{s}\n", .{name});
    }
}

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    var args = try zdf.Args.init(allocator);
    defer args.deinit();

    if (args.argc < 2) {
        try usage();
        return;
    }

    if (args.has("-l") or args.has("--list")) {
        try printAvailable();
        return;
    }

    const filenames = data.filenames;
    const contents = data.contents;

    for (filenames) |filename, i| {
        for (args.argv[1..]) |arg| {
            if (std.ascii.eqlIgnoreCase(arg, filename)) {
                try stdout.writeAll(contents[i]);
                break;
            }
        }
    }
}
