const std = @import("std");
const clap = @import("clap");

fn get_number(buffer: []const u8) ?u64 {
    if (buffer.len == 0)
        return null;
    if (buffer[0] == '0' or std.mem.startsWith(u8, buffer, "zero")) {
        return 0;
    } else if (buffer[0] == '1' or std.mem.startsWith(u8, buffer, "one")) {
        return 1;
    } else if (buffer[0] == '2' or std.mem.startsWith(u8, buffer, "two")) {
        return 2;
    } else if (buffer[0] == '3' or std.mem.startsWith(u8, buffer, "three")) {
        return 3;
    } else if (buffer[0] == '4' or std.mem.startsWith(u8, buffer, "four")) {
        return 4;
    } else if (buffer[0] == '5' or std.mem.startsWith(u8, buffer, "five")) {
        return 5;
    } else if (buffer[0] == '6' or std.mem.startsWith(u8, buffer, "six")) {
        return 6;
    } else if (buffer[0] == '7' or std.mem.startsWith(u8, buffer, "seven")) {
        return 7;
    } else if (buffer[0] == '8' or std.mem.startsWith(u8, buffer, "eight")) {
        return 8;
    } else if (buffer[0] == '9' or std.mem.startsWith(u8, buffer, "nine")) {
        return 9;
    }
    return null;
}

fn do_the_other_thing() u64 {
    const input_file = @embedFile("./input.txt");
    var it = std.mem.split(u8, input_file, "\n");
    var result: u64 = 0;
    while (it.next()) |x| {
        var first_digit: ?u8 = null;
        var last_digit: u8 = 0;
        for (0..x.len) |i| {
            const possible_digit = get_number(x[i..]);
            if (possible_digit) |new_digit| {
                if (first_digit == null)
                    first_digit = new_digit;
                last_digit = new_digit;
            }
        }
        if (first_digit) |good_digit| {
            result += good_digit * 10 + last_digit;
        }
    }
    return result;
}

fn do_the_thing() u64 {
    const input_file = @embedFile("./input.txt");
    var it = std.mem.split(u8, input_file, "\n");
    var result: u64 = 0;
    while (it.next()) |x| {
        var first_digit: ?u8 = null;
        var last_digit: u8 = 0;
        for (x) |character| {
            if (character >= '0' and character <= '9') {
                if (first_digit == null)
                    first_digit = character;
                last_digit = character;
            }
        }
        if (first_digit) |good_digit| {
            result += (good_digit - '0') * 10 + last_digit - '0';
        }
    }
    return result;
}

pub fn main() !void {
    @setEvalBranchQuota(1000000);

    const params = comptime clap.parseParamsComptime(
        \\-h, --help             Display this help and exit.
        \\-2, --part2            Launch part2 of the day.
    );

    var diag = clap.Diagnostic{};
    var res = clap.parse(clap.Help, &params, clap.parsers.default, .{}) catch |err| {
        diag.report(std.io.getStdErr().writer(), err) catch {};
        return err;
    };
    defer res.deinit();

    if (res.args.help != 0)
        return clap.help(std.io.getStdErr().writer(), clap.Help, &params, .{});
    if (res.args.part2 != 0) {
        const stdout = std.io.getStdOut().writer();
        const result = comptime do_the_other_thing();
        try stdout.print("{}\n", .{result});
    } else {
        const stdout = std.io.getStdOut().writer();
        const result = comptime do_the_thing();
        try stdout.print("{}\n", .{result});
    }
}

test "slice_tests" {
    const first: []const u8 = "ahello";
    const second: []const u8 = "hello";

    try std.testing.expect(!std.mem.eql(u8, first, second));
    try std.testing.expect(std.mem.startsWith(u8, first[1..], second));
}
