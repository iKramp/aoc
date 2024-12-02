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

    var first = std.ArrayList(i32).init(allocator);
    defer first.deinit();
    var second = std.ArrayList(i32).init(allocator);
    defer second.deinit();

    var num: i32 = 0;
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
        const intCast: i32 = @intCast(item - '0');
        num += intCast;
    }

    std.mem.sort(i32, first.items, {}, comptime std.sort.asc(i32));
    std.mem.sort(i32, second.items, {}, comptime std.sort.asc(i32));

    var result: u32 = 0;

    for (0.., first.items) |i, elem| {
        result += @abs(elem - second.items[i]);
    }

    try stdout.print("Read ", .{});
    try stdout.print("{any}, {any}, difference is {any}", .{ first.items, second.items, result });
}
