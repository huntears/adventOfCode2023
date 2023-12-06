const std = @import("std");
const clap = @import("clap");

const Race = struct {
    time: usize,
    distance: usize,
};

const races = [_]Race{
    .{
        .time = 58,
        .distance = 434,
    },
    .{
        .time = 81,
        .distance = 1041,
    },
    .{
        .time = 96,
        .distance = 2219,
    },
    .{
        .time = 76,
        .distance = 1218,
    },
};

const final_race = Race{ .time = 58819676, .distance = 434104122191218 };

fn do_the_other_thing() u64 {
    var result: u64 = 0;

    const distance_to_beat = final_race.distance;
    const max_time = final_race.time;
    for (0..max_time) |i| {
        const remaining_time_to_race = max_time - i;
        if (remaining_time_to_race * i > distance_to_beat)
            result += 1;
    }

    return result;
}

fn do_the_thing() u64 {
    var result: ?u64 = null;

    for (races) |race| {
        const distance_to_beat = race.distance;
        const max_time = race.time;
        var number_of_ways_to_beat: u64 = 0;
        for (0..max_time) |i| {
            const remaining_time_to_race = max_time - i;
            if (remaining_time_to_race * i > distance_to_beat)
                number_of_ways_to_beat += 1;
        }
        if (result) |res| {
            result = res * number_of_ways_to_beat;
        } else {
            result = number_of_ways_to_beat;
        }
    }
    return result orelse 0;
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
