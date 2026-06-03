from std.sys import stdin, stdout

def main():
    # Yes, this is required.
    var stdin = stdin
    var stdout = stdout
    var buffer = List[UInt8](length=1024, fill=UInt8(0))
    while True:
        var size: Int = 0
        try:
            size = Int(stdin.read_bytes(buffer))
            if size == 0:
                break
        except e:
            print("Error reading stdin:", e)
            std.sys.terminate.exit(1)

        # According to Mojo, writing to stdout cannot fail!
        stdout.write_bytes(buffer[0:size])
