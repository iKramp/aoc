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

    const split_list = try splitString(allocator, list.items, '\n');
    defer {
        for (split_list) |sub_list| {
            allocator.free(sub_list);
        }
        allocator.free(split_list);
    }

    var final_reports = std.ArrayList([]i32).init(allocator);
    defer {
        for (final_reports.items) |report| {
            allocator.free(report);
        }
        final_reports.deinit();
    }

    for (split_list) |sub_list| {
        const sub_list_split = try splitString(allocator, sub_list, ' ');
        defer {
            for (sub_list_split) |item| {
                allocator.free(item);
            }
            allocator.free(sub_list_split);
        }

        var report = std.ArrayList(i32).init(allocator);
        for (sub_list_split) |item| {
            var num: i32 = 0;
            for (item) |c| {
                num = num * 10 + (c - '0');
            }
            try report.append(num);
        }
        try final_reports.append(try report.toOwnedSlice());
    }

    part_one(final_reports);
    try part_two(final_reports, allocator);
}

fn part_one(final_reports: std.ArrayList([]i32)) void {
    var sum: u32 = 0;
    for (final_reports.items) |report| {
        if (checkReport(report)) {
            sum += 1;
        }
    }

    std.log.info("Part 1 ", .{});
    std.log.info("sum {any}", .{sum});
}

fn part_two(final_reports: std.ArrayList([]i32), allocator: std.mem.Allocator) !void {
    var sum: u32 = 0;
    for (final_reports.items) |report| {
        if (checkReport(report)) {
            sum += 1;
            continue;
        }
        for (0..report.len) |i| {
            var newReport = std.ArrayList(i32).init(allocator);
            for (0..report.len) |j| {
                if (i == j) {
                    continue;
                }
                try newReport.append(report[j]);
            }
            if (checkReport(newReport.items)) {
                sum += 1;
                newReport.deinit();
                break;
            }
            newReport.deinit();
        }
    }
    std.log.info("Part 2 ", .{});
    std.log.info("sum {any}", .{sum});
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

fn checkReport(report: []i32) bool {
    std.log.info("checking report {any}", .{report});
    const increasing = report[0] < report[1];
    for (0..report.len - 1) |i| {
        if ((increasing != (report[i] < report[i + 1])) or report[i] == report[i + 1]) {
            std.log.info("not increasing/decreasing", .{});
            return false;
        }
        if (@abs(report[i] - report[i + 1]) > 3) {
            std.log.info("diff > 3", .{});
            return false;
        }
    }
    return true;
}
