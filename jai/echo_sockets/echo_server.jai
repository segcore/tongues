#import "Basic";
#import "Socket";
System :: #import "System";

port :: 1234;

// Both systems provide 'poll', but Windows one is called WSAPoll.
#if OS == .WINDOWS {
    poll :: WSAPoll;
} else {
    #import "POSIX";
}

DataSocket :: struct {
    sock: Socket;
    addr: sockaddr_in6;
}

process :: (it: DataSocket) -> success: bool {
    // --- receive ---
    buf: [1024]u8;
    received := recv(it.sock, buf.data, buf.count, MSG.DONTWAIT);
    if received == 0 {
        log("Client % disconnected normally\n", it.sock);
        return false;
    }

    buf_rx: []u8;
    if received < 0 {
        if get_last_socket_error() != SOCKET_WOULDBLOCK {
            error_code, error_string := System.get_error_value_and_string();
            log("Client % receive failed. %: %\n", it.sock, error_code, error_string);
            return false;
        }
    } else {
        buf_rx = array_view(buf, 0, received);
        log("Client %: received % bytes: %\n", it.sock, received, buf_rx);
    }

    // --- do stuff with received data ---
    if buf_rx {
        sent := send(it.sock, buf_rx.data, xx buf_rx.count, MSG.NOSIGNAL);
        log("Client %: sent % bytes\n", it.sock, sent);
        if sent < 0 {
            error_code, error_string := System.get_error_value_and_string();
            log("Client % send (echo) failed: %: %\n", it.sock, error_code, error_string);
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
    log("Listening on %\n", to_string(bind_address),, temp);

    data_sockets: [..]DataSocket;
    defer array_free(data_sockets);
    poll_sockets: [..]pollfd;
    defer array_free(poll_sockets);

    array_add(*poll_sockets, pollfd.{fd = listener, events = POLLIN});

    while true {
        accepted, addr := accept_v6(listener);
        if accepted == -1 {
            if get_last_socket_error() != SOCKET_WOULDBLOCK {
                log_error("Accept failed\n");
                break;
            }
        } else {
            log("Accepted a new connection: %  at address %\n", accepted, to_string(addr),, temp);
            array_add(*data_sockets, .{accepted, addr});
            array_add(*poll_sockets, pollfd.{fd = accepted, events = POLLIN});
        }

        for ds: data_sockets {
            if !process(ds) {
                for poll_sockets if it.fd == ds.sock remove it;
                close_and_reset(*ds.sock);
                remove ds;
            }
        }

        timeout: s32 = -1;
        poll(poll_sockets.data, xx poll_sockets.count, timeout);
    }
}

bind :: (s: Socket, bind_address: sockaddr_in6) -> s32 {
    return bind(s, cast(*sockaddr)*bind_address, size_of(type_of(bind_address)));
}
