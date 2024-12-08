const std = @import("std");

const test_val = struct {
    res: u64,
    input: []my_num,
};

const my_num = struct {
    num: u64,
    digits: u32,
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
    const parsed = try parse_input(&lines, allocator);
    defer {
        for (parsed) |item| {
            allocator.free(item.input);
        }
        allocator.free(parsed);
    }

    try solve(parsed);
}

fn parse_input(input: *std.mem.SplitIterator(u8, std.mem.DelimiterType.scalar), allocator: std.mem.Allocator) ![]test_val {
    var res = std.ArrayList(test_val).init(allocator);

    while (input.next()) |line| {
        if (line.len == 0) {
            continue;
        }
        const val = try parse_line(line, allocator);
        try res.append(val);
    }

    return res.toOwnedSlice();
}

fn parse_line(input: []const u8, allocator: std.mem.Allocator) !test_val {
    const colon = std.mem.indexOfScalar(u8, input, ':').?;
    const res = try std.fmt.parseInt(u64, input[0..colon], 0);
    const rest = input[colon + 2 ..];
    var idk = std.mem.splitScalar(u8, rest, ' ');
    var idk2 = std.ArrayList(my_num).init(allocator);
    while (idk.next()) |item| {
        const val = try std.fmt.parseInt(u64, item, 0);
        try idk2.append(my_num{ .num = val, .digits = @intCast(item.len) });
    }
    return test_val{ .res = res, .input = try idk2.toOwnedSlice() };
}

fn solve(input: []test_val) !void {
    var sum_1: u64 = 0;
    var sum_2: u64 = 0;
    for (input) |item| {
        const res_1 = countPossibleEquations(item.input, 0, item.res, false);
        const res_2 = countPossibleEquations(item.input[1..], item.input[0].num, item.res, true);
        if (res_1) {
            sum_1 += item.res;
        }
        if (res_2) {
            sum_2 += item.res;
        }
    }

    std.debug.print("Part 1\n", .{});
    std.debug.print("Result: {any}\n", .{sum_1});
    std.debug.print("Part 2\n", .{});
    std.debug.print("Result: {any}\n", .{sum_2});
}

fn countPossibleEquations(input: []my_num, curr: u64, target: u64, concat: bool) bool {
    if (input.len == 0) {
        if (curr == target) {
            return true;
        } else {
            return false;
        }
    }
    const sum = countPossibleEquations(input[1..], curr + input[0].num, target, concat);
    const prod = countPossibleEquations(input[1..], curr * input[0].num, target, concat);
    const concat_res = concat and countPossibleEquations(input[1..], curr * std.math.pow(u64, 10, input[0].digits) + input[0].num, target, concat);
    return sum or prod or concat_res;
}
