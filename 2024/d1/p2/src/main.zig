const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.deinit();
    }

    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    var list = std.ArrayList(u8).init(allocator);
    defer list.deinit();
    try stdin.readAllArrayList(&list, std.math.maxInt(i32));

    var first = std.ArrayList(u32).init(allocator);
    defer first.deinit();
    var second = std.ArrayList(u32).init(allocator);
    defer second.deinit();

    var num: u32 = 0;
    for (list.items) |item| {
        if (item == ' ') {
            if (num == 0) {
                continue;
            }
            try first.append(num);
            num = 0;
            continue;
        } else if (item == '\n') {
            if (num == 0) {
                continue;
            }
            try second.append(num);
            num = 0;
            continue;
        }
        num *= 10;
        const intCast: u32 = @intCast(item - '0');
        num += intCast;
    }

    std.mem.sort(u32, first.items, {}, comptime std.sort.asc(u32));

    var result: u32 = 0;

    for (first.items) |item| {
        var num_found: u32 = 0;
        for (second.items) |item2| {
            if (item == item2) {
                num_found += 1;
            }
        }
        result += num_found * item;
    }

    try stdout.print("Read ", .{});
    try stdout.print("{any}, {any}, difference is {any}", .{ first.items, second.items, result });
}
