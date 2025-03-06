#import "Basic";
#import "File";
#import "POSIX";

main :: () {
    in : File = .{stdin};
    out : File = .{stdout};

    buffer : [2048]u8;
    while true {
        ok, read := file_read(in, buffer.data, buffer.count);
        if !ok {
            print("Failed to read from stdin\n", to_standard_error = true);
            exit(1);
        }
        if read == 0 break;

        ok = file_write(*out, buffer.data, read);
        if !ok {
            print("Failed to write bytes to stdout\n", to_standard_error = true);
            exit(1);
        }
    }
}
