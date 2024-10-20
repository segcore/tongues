const std = @import("std");
pub fn main() u8 {
    var exit_code: u8 = 0;
    const stdout = std.io.getStdOut();
    const stdin = std.io.getStdIn();
    const stderr = std.io.getStdErr();

    var buffer : [1024]u8 = undefined;
    while (true) {
        const count = stdin.read(&buffer) catch |err| {
            stderr.writer().print("Failed to read from stdin: {}\n", .{err}) catch {};
            exit_code = 1;
            break;
        };
        if(count == 0) break;
        _ = stdout.write(buffer[0..count]) catch |err| {
            stderr.writer().print("Failed to write to stdout: {}\n", .{err}) catch {};
            exit_code = 1;
            break;
        };
    }
    return exit_code;
}
