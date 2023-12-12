const std = @import("std");
const clap = @import("clap");

const input_file = @embedFile("input.txt");

const Galaxy = struct {
    const Self = @This();

    x: u64,
    y: u64,

    fn diff(self: Self, other: Galaxy) Galaxy {
        return Galaxy{
            .x = @max(self.x, other.x) - @min(self.x, other.x),
            .y = @max(self.y, other.y) - @min(self.y, other.y),
        };
    }
};

var gpa = std.heap.GeneralPurposeAllocator(.{}){};

fn get_splitted_input_file() std.ArrayList([]const u8) {
    var splitted = std.ArrayList([]const u8).init(gpa.allocator());
    var iter = std.mem.split(u8, input_file, "\n");
    while (iter.next()) |current_line| {
        if (current_line.len == 0)
            continue;
        splitted.append(current_line) catch @panic("something really bad");
    }
    return splitted;
}

fn get_lines_to_expand(split_input_file: *const std.ArrayList([]const u8)) std.ArrayList(u8) {
    var lines = std.ArrayList(u8).init(gpa.allocator());
    outer: for (0..split_input_file.items.len) |i| {
        for (split_input_file.items[i]) |x| {
            if (x == '#')
                continue :outer;
        }
        lines.append(@truncate(i)) catch @panic("something really bad");
    }
    return lines;
}

fn get_columns_to_expand(split_input_file: *const std.ArrayList([]const u8)) std.ArrayList(u8) {
    var columns = std.ArrayList(u8).init(gpa.allocator());
    outer: for (0..split_input_file.items[0].len) |i| {
        for (0..split_input_file.items.len) |x| {
            if (split_input_file.items[x][i] == '#')
                continue :outer;
        }
        columns.append(@truncate(i)) catch @panic("something really bad");
    }
    return columns;
}

fn get_galaxies(split_input_file: *const std.ArrayList([]const u8)) std.ArrayList(Galaxy) {
    var galaxies = std.ArrayList(Galaxy).init(gpa.allocator());

    for (0..split_input_file.items.len) |y| {
        for (0..split_input_file.items[0].len) |x| {
            if (split_input_file.items[y][x] == '#') {
                galaxies.append(Galaxy{
                    .x = x,
                    .y = y,
                }) catch @panic("something really bad");
            }
        }
    }
    return galaxies;
}

fn do_the_whole_thing(expansion_fact: u64) u64 {
    var result: u64 = 0;
    const expansion_factor = expansion_fact - 1;

    const splitted_file = get_splitted_input_file();
    defer splitted_file.deinit();
    const lines_to_expand = get_lines_to_expand(&splitted_file);
    defer lines_to_expand.deinit();
    const columns_to_expand = get_columns_to_expand(&splitted_file);
    defer columns_to_expand.deinit();
    const galaxies = get_galaxies(&splitted_file);
    defer galaxies.deinit();

    for (0..galaxies.items.len) |i| {
        for (i + 1..galaxies.items.len) |y| {
            const first = galaxies.items[i];
            const second = galaxies.items[y];
            const diff = first.diff(second);
            const smallest_x = @min(first.x, second.x);
            const smallest_y = @min(first.y, second.y);
            const biggest_x = @max(first.x, second.x);
            const biggest_y = @max(first.y, second.y);

            var to_expand: u8 = 0;
            for (lines_to_expand.items) |x| {
                if (x > smallest_y and x < biggest_y) {
                    to_expand += 1;
                }
            }
            for (columns_to_expand.items) |x| {
                if (x > smallest_x and x < biggest_x) {
                    to_expand += 1;
                }
            }
            result += diff.x + diff.y + to_expand * expansion_factor;
        }
    }

    return result;
}

fn do_the_other_thing() u64 {
    return do_the_whole_thing(1_000_000);
}

fn do_the_thing() u64 {
    return do_the_whole_thing(2);
}

pub fn main() !void {
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
        const result = do_the_other_thing();
        try stdout.print("{}\n", .{result});
    } else {
        const stdout = std.io.getStdOut().writer();
        const result = do_the_thing();
        try stdout.print("{}\n", .{result});
    }
}
