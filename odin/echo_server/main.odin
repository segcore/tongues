package main

import "core:net"
import "core:os"
import "core:fmt"

echo_server :: proc() -> (err: net.Network_Error) {
    listen_addr : net.Endpoint = {
        address = net.IP4_Loopback,
        port = 6969,
    }
    listener := net.listen_tcp(listen_addr, 20) or_return
    defer net.close(listener)
    fmt.printfln("Listening on %v", listen_addr)

    for {
        datasock, source := net.accept_tcp(listener) or_return
        defer net.close(datasock)

        fmt.printfln("Accepted connection from %v on socket %v", source, datasock)
        for {
            buf : [1024]u8;
            n := net.recv_tcp(datasock, buf[:]) or_break
            if n == 0 {
                fmt.println("End of socket data")
                break
            } else {
                fmt.printfln("Client sent %q", string(buf[:n]))
            }
        }
        fmt.printfln("Connection closed, socket %v", source, datasock)
    }

    return nil
}

main :: proc() {
    err := echo_server()
    if err != nil {
        os.exit(1)
    }
}
