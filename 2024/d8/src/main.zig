const std = @import("std");

const Coord = struct {
    x: i32,
    y: i32,
};

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
    var grid_list = std.ArrayList([]const u8).init(allocator);
    while (lines.next()) |line| {
        if (line.len == 0) {
            break;
        }
        try grid_list.append(line);
    }
    const grid = try grid_list.toOwnedSlice();
    defer allocator.free(grid);

    var towers = std.AutoHashMap(u8, *std.ArrayList(Coord)).init(allocator);
    defer {
        var values = towers.valueIterator();
        while (values.next()) |tower| {
            tower.*.deinit();
            allocator.destroy(tower.*);
        }
        towers.deinit();
    }
    for (0..grid.len) |y| {
        for (0..grid[y].len) |x| {
            const c = grid[y][x];
            if ((c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or c >= '0' and c <= '9') {
                if (!towers.contains(c)) {
                    const new_list_ptr = try allocator.create(std.ArrayList(Coord));
                    new_list_ptr.* = std.ArrayList(Coord).init(allocator);
                    try towers.put(c, new_list_ptr);
                }
                try towers.get(c).?.append(Coord{ .x = @intCast(x), .y = @intCast(y) });
            }
        }
    }

    try part_1(towers, Coord{ .x = @intCast(grid[0].len), .y = @intCast(grid.len) });
    try part_2(towers, Coord{ .x = @intCast(grid[0].len), .y = @intCast(grid.len) });
}

fn part_1(towers: std.AutoHashMap(u8, *std.ArrayList(Coord)), size: Coord) !void {
    var spots = std.AutoHashMap(Coord, void).init(std.heap.page_allocator); //because zig doesn't have sets
    defer spots.deinit();
    var values = towers.valueIterator();
    while (values.next()) |tower_type| {
        const tower_items = tower_type.*.items;
        for (0..tower_items.len) |i| {
            for (i + 1..tower_items.len) |j| {
                const x1 = tower_items[i].x - (tower_items[j].x - tower_items[i].x);
                const y1 = tower_items[i].y - (tower_items[j].y - tower_items[i].y);
                const x2 = tower_items[j].x + (tower_items[j].x - tower_items[i].x);
                const y2 = tower_items[j].y + (tower_items[j].y - tower_items[i].y);

                std.debug.print("tower 1: {} {}\n", .{ tower_items[i].x, tower_items[i].y });
                std.debug.print("tower 2: {} {}\n", .{ tower_items[j].x, tower_items[j].y });

                if (!(x1 < 0 or y1 < 0 or x1 >= size.x or y1 >= size.y)) {
                    try spots.put(Coord{ .x = x1, .y = y1 }, {});
                }
                if (!(x2 < 0 or y2 < 0 or x2 >= size.x or y2 >= size.y)) {
                    try spots.put(Coord{ .x = x2, .y = y2 }, {});
                }
            }
        }
    }
    const result = spots.count();

    std.debug.print("Part 1: {}\n", .{result});
}

fn part_2(towers: std.AutoHashMap(u8, *std.ArrayList(Coord)), size: Coord) !void {
    var spots = std.AutoHashMap(Coord, void).init(std.heap.page_allocator); //because zig doesn't have sets
    defer spots.deinit();
    var values = towers.valueIterator();
    while (values.next()) |tower_type| {
        const tower_items = tower_type.*.items;
        for (0..tower_items.len) |i| {
            for (i + 1..tower_items.len) |j| {
                var diff = Coord{ .x = tower_items[j].x - tower_items[i].x, .y = tower_items[j].y - tower_items[i].y };
                for (2..@intCast(size.x)) |k_usize| {
                    const k: i32 = @intCast(k_usize);
                    while (@mod(diff.x, k) == 0 and @mod(diff.y, k) == 0) {
                        diff = Coord{ .x = @divExact(diff.x, k), .y = @divExact(diff.y, k) };
                    }
                }
                for (0..@intCast(size.x)) |k_usize| {
                    const k: i32 = @intCast(k_usize);
                    const x1 = tower_items[j].x + diff.x * k;
                    const y1 = tower_items[j].y + diff.y * k;
                    const x2 = tower_items[i].x - diff.x * k;
                    const y2 = tower_items[i].y - diff.y * k;

                    if (!(x1 < 0 or y1 < 0 or x1 >= size.x or y1 >= size.y)) {
                        try spots.put(Coord{ .x = x1, .y = y1 }, {});
                    }
                    if (!(x2 < 0 or y2 < 0 or x2 >= size.x or y2 >= size.y)) {
                        try spots.put(Coord{ .x = x2, .y = y2 }, {});
                    }
                }
            }
        }
    }
    const result = spots.count();

    std.debug.print("Part 1: {}\n", .{result});
}
