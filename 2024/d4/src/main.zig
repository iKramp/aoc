const std = @import("std");

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
    for (0..15) |_| {
        try list.append(' ');
    }

    const slice = try list.toOwnedSlice();
    defer allocator.free(slice);
    var lines = std.mem.split(u8, slice, "\n");
    const width = lines.peek().?.len;

    var lines_list = std.ArrayList([]const u8).init(allocator);
    defer lines_list.deinit();

    while (lines.next()) |line| {
        if (line.len == width) {
            try lines_list.append(line);
        }
    }

    std.log.info("dimensions are: ({}, {})", .{ lines_list.items.len, lines_list.items[0].len });
    part1(lines_list.items);
    part2(lines_list.items);
}
fn part1(input: [][]const u8) void {
    var sum: u32 = 0;

    for (0..input.len) |i| {
        for (0..input[i].len) |j| {
            sum += check_all_directions(input, @intCast(i), @intCast(j));
        }
    }

    std.log.info("Part 1 ", .{});
    std.log.info("Sum: {}\n", .{sum});
}

fn part2(input: [][]const u8) void {
    var sum: u32 = 0;

    for (0..input.len) |i| {
        for (0..input[i].len) |j| {
            if (check_x_mas(input, @intCast(i), @intCast(j))) {
                sum += 1;
            }
        }
    }

    std.log.info("Part 2 ", .{});
    std.log.info("Sum: {}\n", .{sum});
}

fn check_all_directions(input: [][]const u8, x: isize, y: isize) u32 {
    var sum: u32 = 0;
    const directions = [_][2]isize{ [_]isize{ 0, 1 }, [_]isize{ 0, -1 }, [_]isize{ 1, 0 }, [_]isize{ -1, 0 }, [_]isize{ 1, 1 }, [_]isize{ 1, -1 }, [_]isize{ -1, 1 }, [_]isize{ -1, -1 } };
    for (directions) |dir| {
        if (check_xmas(input, x, y, dir[0], dir[1])) {
            sum += 1;
        }
    }
    return sum;
}

fn check_xmas(input: [][]const u8, x: isize, y: isize, dx: isize, dy: isize) bool {
    if (x + 3 * dx < 0 or y + 3 * dy < 0 or x + dx * 3 >= input.len or y + dy * 3 >= input[0].len) {
        return false;
    }
    if (input[@intCast(x)][@intCast(y)] == 'X' and
        input[@intCast(x + dx)][@intCast(y + dy)] == 'M' and
        input[@intCast(x + 2 * dx)][@intCast(y + 2 * dy)] == 'A' and
        input[@intCast(x + 3 * dx)][@intCast(y + 3 * dy)] == 'S')
    {
        return true;
    }
    return false;
}

fn check_x_mas(input: [][]const u8, x: isize, y: isize) bool {
    if (x == 0 or y == 0 or x >= input.len - 1 or y >= input[0].len - 1) {
        return false;
    }

    const directions = [_][2]isize{ [_]isize{ 1, 1 }, [_]isize{ 1, -1 }, [_]isize{ -1, 1 }, [_]isize{ -1, -1 } };

    for (directions) |dir| {
        if (input[@intCast(x)][@intCast(y)] == 'A' and
            input[@intCast(x + dir[0])][@intCast(y + dir[0])] == 'M' and
            input[@intCast(x + dir[1])][@intCast(y - dir[1])] == 'M' and
            input[@intCast(x - dir[0])][@intCast(y - dir[0])] == 'S' and
            input[@intCast(x - dir[1])][@intCast(y + dir[1])] == 'S')
        {
            return true;
        }
    }
    return false;
}
