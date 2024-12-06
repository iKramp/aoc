const std = @import("std");

const Order = struct {
    first: u32,
    second: u32,
};

const Update = struct { pages: []u32 };

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.deinit();
    }

    const stdin = std.io.getStdIn().reader();

    var list = std.ArrayList(u8).init(allocator);
    defer list.deinit();
    try stdin.readAllArrayList(&list, std.math.maxInt(i32));
    var lines = std.mem.splitScalar(u8, list.items, '\n');

    var orders = std.ArrayList(Order).init(allocator);
    defer orders.deinit();

    while (lines.next()) |line| {
        if (line.len == 0) {
            break;
        }

        const first = (line[0] - '0') * 10 + (line[1] - '0');
        const second = (line[3] - '0') * 10 + (line[4] - '0');

        const order = Order{ .first = first, .second = second };
        try orders.append(order);
    }

    var updates = std.ArrayList(Update).init(allocator);
    defer {
        for (updates.items) |update| {
            allocator.free(update.pages);
        }
        updates.deinit();
    }

    var update = std.ArrayList(u32).init(allocator);
    defer update.deinit();

    while (lines.next()) |line| {
        if (line.len == 0) {
            break;
        }
        var nums = std.mem.splitScalar(u8, line, ',');

        while (nums.next()) |num| {
            if (num.len == 0) {
                break;
            }
            var page: u32 = 0;
            for (0..num.len) |i| {
                page = (num[i] - '0') + (page * 10);
            }
            try update.append(page);
        }
        update.shrinkAndFree(update.items.len);
        try updates.append(Update{ .pages = update.items });
        update = std.ArrayList(u32).init(allocator);
    }
    solve(orders.items, updates.items);
}

fn solve(orders: []Order, updates: []Update) void {
    var sum_1: u32 = 0;
    var sum_2: u32 = 0;

    for (updates) |update| {
        const pages = update.pages;
        if (correct_update(orders, update)) {
            sum_1 += pages[pages.len / 2];
        } else {
            sort(orders, update.pages);
            sum_2 += pages[pages.len / 2];
        }
    }

    std.log.info("Part 1:", .{});
    std.log.info("{d}", .{sum_1});
    std.log.info("Part 2:", .{});
    std.log.info("{d}", .{sum_2});
}

fn correct_update(orders: []Order, update: Update) bool {
    for (0..update.pages.len - 1) |i| {
        for (i + 1..update.pages.len) |j| {
            if (!correct_order(orders, update.pages[i], update.pages[j])) {
                return false;
            }
        }
    }
    return true;
}

fn correct_order(orders: []Order, page_1: u32, page_2: u32) bool {
    for (orders) |order| {
        if (order.first == page_2 and order.second == page_1) {
            return false;
        }
    }
    return true;
}

fn sort(orders: []Order, update_pages: []u32) void {
    for (0..update_pages.len) |_| {
        for (0..update_pages.len - 1) |i| {
            if (!correct_order(orders, update_pages[i], update_pages[i + 1])) {
                const temp = update_pages[i];
                update_pages[i] = update_pages[i + 1];
                update_pages[i + 1] = temp;
            }
        }
    }
}
