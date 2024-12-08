const std = @import("std");

const Coords = struct {
    x: i32,
    y: i32,
};

const gridResult = enum {
    Ok,
    Loop,
};

const sumlationType = struct {
    grid: [][]u8,
    result: gridResult,
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
    defer grid_list.deinit();
    while (lines.next()) |line| {
        if (line.len == 0) continue;
        try grid_list.append(line);
    }

    try part1(grid_list.items);
    try part2(grid_list.items);
}

fn part1(grid: [][]const u8) !void {
    const guard = find_guard(grid);

    var checked_grid = try copy_grid(grid, std.heap.page_allocator);
    defer free_grid(checked_grid, std.heap.page_allocator);
    checked_grid = simulate_grid(checked_grid, guard).grid;

    std.log.info("Part 1\n", .{});
    std.log.info("Number: {d}\n", .{count_X(checked_grid)});
}

fn part2(grid: [][]const u8) !void {
    const guard = find_guard(grid);
    var loops: u32 = 0;

    for (0..grid.len) |y| {
        for (0..grid[y].len) |x| {
            var checked_grid = try copy_grid(grid, std.heap.page_allocator);
            checked_grid[@intCast(x)][@intCast(y)] = '#';
            defer free_grid(checked_grid, std.heap.page_allocator);
            const res = simulate_grid(checked_grid, guard).result;
            if (res == gridResult.Loop) {
                loops += 1;
            }
        }
    }

    std.log.info("Part 2\n", .{});
    std.log.info("Number: {d}\n", .{loops});
}

fn simulate_grid(grid: [][]u8, guard_in: Coords) sumlationType {
    const size_x = grid.len;
    const size_y = grid[0].len;
    var guard = guard_in;
    grid[@intCast(guard.x)][@intCast(guard.y)] = 'X';
    var direction = Coords{ .x = -1, .y = 0 };

    var steps: u32 = 0;

    while (guard.x > 0 and guard.x < size_x - 1 and guard.y > 0 and guard.y < size_y - 1) {
        if (grid[@intCast(guard.x + direction.x)][@intCast(guard.y + direction.y)] == '#') {
            direction = Coords{ .x = direction.y, .y = -direction.x };
        } else {
            guard.x += direction.x;
            guard.y += direction.y;
            grid[@intCast(guard.x)][@intCast(guard.y)] = 'X';
            steps += 1;
        }
        if (steps > size_x * size_y) {
            return sumlationType{ .grid = grid, .result = gridResult.Loop };
        }
    }
    return sumlationType{ .grid = grid, .result = gridResult.Ok };
}

fn print_grid(grid: [][]u8) void {
    for (0..grid.len) |y| {
        std.debug.print("{s}", .{grid[y]});
        std.debug.print("\n", .{});
    }
    std.debug.print("\n", .{});
}

fn find_guard(grid: [][]const u8) Coords {
    for (0..grid.len) |y| {
        for (0..grid[y].len) |x| {
            if (grid[x][y] == '^') {
                return Coords{ .x = @intCast(x), .y = @intCast(y) };
            }
        }
    }
    return Coords{ .x = @intCast(-1), .y = @intCast(-1) };
}

fn count_X(grid: [][]const u8) i32 {
    var count: i32 = 0;
    for (0..grid.len) |y| {
        for (0..grid[y].len) |x| {
            if (grid[y][x] == 'X') {
                count += 1;
            }
        }
    }
    return count;
}

fn copy_grid(grid: [][]const u8, allocator: std.mem.Allocator) ![][]u8 {
    const size_x = grid.len;
    const size_y = grid[0].len;
    var new_grid = try allocator.alloc([]u8, size_x);
    for (0..size_x) |i| {
        new_grid[i] = try allocator.alloc(u8, size_y);
        for (0..size_y) |j| {
            new_grid[i][j] = grid[i][j];
        }
    }
    return new_grid;
}

fn free_grid(grid: [][]u8, allocator: std.mem.Allocator) void {
    for (0..grid.len) |i| {
        allocator.free(grid[i]);
    }
    allocator.free(grid);
}
