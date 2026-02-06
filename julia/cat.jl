#!/usr/bin/env julia
count = 0
while true
    bytes = read(stdin, 1024)
    if length(bytes) == 0 break; end
    written = write(stdout, bytes);
    if written != length(bytes)
        println("Failed to write all bytes to stdout");
        exit(1)
    end
end
