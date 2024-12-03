const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.deinit();
    }

    const stdin = std.io.getStdIn().reader();

    var list = std.ArrayList(u8).init(allocator);
    try stdin.readAllArrayList(&list, std.math.maxInt(i32));
    for (0..15) |_| {
        try list.append(' ');
    }

    const slice = try list.toOwnedSlice();
    defer allocator.free(slice);

    part1(slice);
    part2(slice);
}

fn splitString(allocator: std.mem.Allocator, input: []const u8, delimiter: u8) ![][]u8 {
    var list = std.ArrayList([]u8).init(allocator);
    var sub_list = std.ArrayList(u8).init(allocator);
    for (input) |c| {
        if (c == delimiter) {
            try list.append(try sub_list.toOwnedSlice());
            sub_list = std.ArrayList(u8).init(allocator);
        } else {
            try sub_list.append(c);
        }
    }
    if (sub_list.items.len > 0) {
        try list.append(try sub_list.toOwnedSlice());
    } else {
        allocator.free(sub_list.items);
    }

    return list.toOwnedSlice();
}

fn part1(input: []u8) void {
    var sum: u32 = 0;
    var i: u32 = 0;
    while (i < input.len - 15) {
        sum += check_at_i(input, i);
        i += 1;
    }
    std.log.info("Part 1 ", .{});
    std.log.info("Sum: {}\n", .{sum});
}

fn part2(input: []u8) void {
    var sum: u32 = 0;
    var i: u32 = 0;
    var enabled = true;
    while (i < input.len - 15) {
        if (!enabled and is_do(input, i)) {
            enabled = true;
        } else if (enabled and is_dont(input, i)) {
            enabled = false;
        } else if (enabled) {
            sum += check_at_i(input, i);
        }
        i += 1;
    }
    std.log.info("Part 2 ", .{});
    std.log.info("Sum: {}\n", .{sum});
}

fn check_at_i(input: []u8, in_i: usize) u32 {
    var num1: u32 = 0;
    var num2: u32 = 0;
    var i = in_i;
    if (input[i] == 'm' and input[i + 1] == 'u' and input[i + 2] == 'l' and input[i + 3] == '(') {
        if (input[i + 4] < '0' or input[i + 4] > '9') {
            return 0;
        } else {
            num1 = input[i + 4] - '0';
        }
        if (input[i + 5] >= '0' and input[i + 5] <= '9') {
            num1 = num1 * 10 + input[i + 5] - '0';
            if (input[i + 6] >= '0' and input[i + 6] <= '9') {
                num1 = num1 * 10 + input[i + 6] - '0';
                if (input[i + 7] != ',') {
                    return 0;
                } else {
                    i += 8;
                }
            } else if (input[i + 6] != ',') {
                return 0;
            } else {
                i += 7;
            }
        } else if (input[i + 5] != ',') {
            return 0;
        } else {
            i += 6;
        }
        if (input[i] < '0' or input[i] > '9') {
            return 0;
        } else {
            num2 = input[i] - '0';
        }
        if (input[i + 1] >= '0' and input[i + 1] <= '9') {
            num2 = num2 * 10 + input[i + 1] - '0';
            if (input[i + 2] >= '0' and input[i + 2] <= '9') {
                num2 = num2 * 10 + input[i + 2] - '0';
                if (input[i + 3] != ')') {
                    return 0;
                }
            } else if (input[i + 2] != ')') {
                return 0;
            }
        } else if (input[i + 1] != ')') {
            return 0;
        }
    } else {
        return 0;
    }
    return num1 * num2;
}

fn is_do(input: []u8, i: usize) bool {
    if (input[i] == 'd' and input[i + 1] == 'o' and input[i + 2] == '(' and input[i + 3] == ')') {
        return true;
    }
    return false;
}

fn is_dont(input: []u8, i: usize) bool {
    if (input[i] == 'd' and input[i + 1] == 'o' and input[i + 2] == 'n' and input[i + 3] == '\'' and input[i + 4] == 't' and input[i + 5] == '(' and input[i + 6] == ')') {
        return true;
    }
    return false;
}

//xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
