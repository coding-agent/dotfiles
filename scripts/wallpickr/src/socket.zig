const std = @import("std");
const Allocator = std.mem.Allocator;

const Monitor = struct {
    name: []const u8,
    focused: bool,
};

fn getActiveMonitor(alloc: Allocator, signature: ?[]const u8) ![]const u8 {
    if (signature) |sign| {
        const socket_path = try std.fs.path.join(alloc, &.{ "/tmp", "hypr", sign, ".socket.sock" });
        const hl_stream = try std.net.connectUnixSocket(socket_path);
        defer hl_stream.close();

        try hl_stream.writeAll("[[BATCH]][-j]/monitors;");
        var json_reader = std.json.reader(alloc, hl_stream.reader());

        const monitors: []Monitor = try std.json.innerParse([]Monitor, alloc, &json_reader, .{
            .ignore_unknown_fields = true,
            .allocate = .alloc_if_needed,
            .max_value_len = std.json.default_max_value_len,
        });
        for (monitors) |monitor| {
            if (monitor.focused) {
                return monitor.name;
            }
        }
        unreachable;
    } else {
        //TODO get the active monitor from wayland instead
        return "eDP-1";
    }
}

pub fn setWallpaperToCurrentMonitorHyprpaper(alloc: Allocator, path: []const u8) !void {
    var arena = std.heap.ArenaAllocator.init(alloc);
    defer arena.deinit();

    const buf = try arena.allocator().alloc(u8, 100);

    const instance_signature = std.posix.getenv("HYPRLAND_INSTANCE_SIGNATURE");
    const active_monitor = try getActiveMonitor(arena.allocator(), instance_signature);

    const hyprpaper_socket_path =
        if (instance_signature) |sign|
        try std.fs.path.join(alloc, &.{ "/tmp", "hypr", sign, ".hyprpaper.sock" })
    else
        try std.fs.path.join(alloc, &.{ "/tmp", "hypr", ".hyprpaper.sock" });

    _ = hyprpaper_ipc: {
        const stream = try std.net.connectUnixSocket(hyprpaper_socket_path);
        defer stream.close();

        const preload_msg = try std.mem.concat(arena.allocator(), u8, &[_][]const u8{ "preload ", path });
        const wallpaper_msg = try std.mem.concat(arena.allocator(), u8, &[_][]const u8{
            "wallpaper ",
            active_monitor,
            ",contain:",
            path,
        });
        const unload_msg = "unload all";

        _ = try stream.writer().write(preload_msg);
        _ = try stream.read(buf);
        _ = try stream.writer().write(wallpaper_msg);
        _ = try stream.read(buf);
        _ = try stream.writer().write(unload_msg);
        _ = try stream.read(buf);
        break :hyprpaper_ipc;
    };
}

pub fn setWallpaperToCurrentMonitorAestuarium(alloc: Allocator, path: []const u8) !void {
    var arena = std.heap.ArenaAllocator.init(alloc);
    defer arena.deinit();

    var buf: [4096]u8 = undefined;

    const env = std.posix.getenv("XDG_RUNTIME_DIR") orelse return error.MissingXDGRuntimePath;
    // TODO make aestuarium inform about the focused monitor
    const active_monitor = "eDP-1";

    const aestuarium_socket_path =
        try std.fs.path.join(alloc, &.{ env, "aestuarium.sock" });

    const preload_msg = try std.mem.concat(arena.allocator(), u8, &[_][]const u8{
        "preload ",
        path,
    });

    const wallpaper_msg = try std.mem.concat(arena.allocator(), u8, &[_][]const u8{
        "wallpaper ",
        active_monitor,
        "=",
        path,
    });

    const unload_msg = "unload all";

    var bytes: usize = 0;
    {
        const stream = try std.net.connectUnixSocket(aestuarium_socket_path);
        defer stream.close();
        _ = try stream.write(preload_msg);
        bytes = try stream.read(&buf);
        std.log.info("{s}", .{buf[0..bytes]});
    }
    {
        const stream = try std.net.connectUnixSocket(aestuarium_socket_path);
        defer stream.close();
        _ = try stream.write(wallpaper_msg);
        bytes = try stream.read(&buf);
        std.log.info("{s}", .{buf[0..bytes]});
    }
    {
        const stream = try std.net.connectUnixSocket(aestuarium_socket_path);
        defer stream.close();
        _ = try stream.write(unload_msg);
        bytes = try stream.read(&buf);
        std.log.info("{s}", .{buf[0..bytes]});
    }
}
