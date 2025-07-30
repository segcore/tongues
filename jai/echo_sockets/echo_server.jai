#import "Basic";
#import "Socket";
System :: #import "System";

port :: 1234;

#if OS == .WINDOWS {
    try_again :: WSAEWOULDBLOCK; // not tested
} else {
    #import "POSIX";
    try_again :: EAGAIN;
}

DataSocket :: struct {
    sock: Socket;
    addr: sockaddr_in6;
}

process :: (it: DataSocket) -> success: bool {
    print("Processing %\n", it.sock);
    buf: [1024]u8;
    received := recv(it.sock, buf.data, buf.count, MSG.DONTWAIT);
    if received == 0 {
        print("Client % disconnected normally\n", it.sock);
        return false;
    }

    buf_rx: []u8;
    log("Client % received % bytes\n", it.sock, received);
    if received < 0 {
        if get_last_socket_error() != try_again {
            error_code, error_string := System.get_error_value_and_string();
            print("Client % receive failed. %: %\n", it.sock, error_code, error_string);
            return false;
        }
    } else {
        buf_rx := array_view(buf, 0, received);
    }

    if buf_rx {
        sent := send(it.sock, buf_rx.data, xx buf_rx.count, MSG.NOSIGNAL);
        log("Client % sent % bytes\n", it.sock, sent);
        if sent < 0 {
            error_code, error_string := System.get_error_value_and_string();
            print("Client % send (echo) failed: %: %\n", it.sock, error_code, error_string);
            return false;
        }
    }

    return true;
}


main :: () {
    socket_init();

    listener: Socket = socket(AF_INET6, SOCK.STREAM | .CLOEXEC | .NONBLOCK, 0);

    { v: s32 = 1; setsockopt(listener, SOL_SOCKET, SO_REUSEADDR, *v, size_of(type_of(v))); }

    bind_address: sockaddr_in6;
    bind_address.sin6_family = AF_INET6;
    bind_address.sin6_addr = in6addr_loopback;
    bind_address.sin6_port = htons(port);

    err := bind(listener, bind_address);
    if err {
        log_error("Failed to bind: %\n", err);
        exit(1);
    }
    listen(listener, 5);
    print("Listening on %\n", to_string(bind_address),, temp);

    data_sockets: [..]DataSocket;

    while true {
        accepted, addr := accept_v6(listener);
        if accepted == -1 {
            if get_last_socket_error() != try_again {
                log_error("Accept failed\n");
                break;
            }
        } else {
            print("Accepted a new connection: %  at address %\n", accepted, to_string(addr),, temp);
            array_add(*data_sockets, .{accepted, addr});
        }

        for data_sockets {
            if !process(it) {
                close_and_reset(*it.sock);
                remove it;
            }
        }

        print("Waiting for data change...\n");
        // select seems the supported one for now
        set: fd_set;
        maxfd := listener;
        FD_SET(listener, *set);
        for data_sockets {
            FD_SET(it.sock, *set);
            maxfd = max(maxfd, it.sock);
        }
        except := set;
        select(maxfd + 1, *set, null, *except, null);
    }
}

bind :: (s: Socket, bind_address: sockaddr_in6) -> s32 {
    return bind(s, cast(*sockaddr)*bind_address, size_of(type_of(bind_address)));
}
