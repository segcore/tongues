package echo_async

import "core:net"
import "core:os"
import "core:fmt"
import "core:sys/linux"
import "core:slice"

TCP_Socket :: net.TCP_Socket
Poll_Fd :: linux.Poll_Fd

echo_server :: proc() -> (err: net.Network_Error) {
    listen_addr : net.Endpoint = {
        address = net.IP4_Loopback,
        port = 6969,
    }
    listener := net.listen_tcp(listen_addr, 20) or_return
    defer net.close(listener)
    fmt.printfln("Listening on %v", listen_addr)

    net.set_blocking(listener, false) or_return

    connections, connections_next : [dynamic]TCP_Socket
    pollfds : [dynamic]Poll_Fd

    defer delete(connections)
    defer delete(connections_next)
    defer delete(pollfds)

    append(&pollfds, Poll_Fd{
        fd = linux.Fd(listener),
        events = { .IN , .ERR },
    })

    for {
        assert(len(pollfds) == len(connections_next) + 1)
        linux.poll(pollfds[:], -1)

        {
            datasock, source, err := net.accept_tcp(listener)
            if err == nil {
                fmt.printfln("Accepted connection from %v on socket %v", source, datasock)

                net.set_blocking(datasock, false)
                append(&connections_next, datasock)
                append(&pollfds, Poll_Fd{
                    fd = linux.Fd(datasock),
                    events = { .IN, .ERR },
                })
            } else if err != net.Accept_Error.Would_Block {
                fmt.printfln("Fatal error on accept: %v", err)
                return err
            }
        }

        assert(len(pollfds) == len(connections_next) + 1)
        assert(len(connections) == 0)
        connections, connections_next = connections_next, connections

        for conn in connections {
            keep := true
            buf : [1024]u8;
            n, err := net.recv(conn, buf[:])
            if err == nil {
                if n == 0 {
                    fmt.printfln("End of data. Connection closed, socket %v", conn)
                    net.close(conn)
                    keep = false

                    for fd, index in pollfds {
                        if fd.fd == linux.Fd(conn) {
                            unordered_remove(&pollfds, index)
                            break
                        }
                    }
                } else {
                    fmt.printfln("Client %v sent %q", conn, string(buf[:n]))
                }
            } else if err != net.TCP_Recv_Error.Timeout {
                fmt.printfln("Fatal error on recv: %v", err)
                return err
            }
            if keep do append(&connections_next, conn)
        }
        clear(&connections)
    }

    return nil
}

main :: proc() {
    err := echo_server()
    if err != nil {
        os.exit(1)
    }
}
