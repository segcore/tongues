package cat
import "core:io"
import "core:os"
import "core:fmt"

main :: proc() {
    stdout := os.stream_from_handle(os.stdout);
    stdin := os.stream_from_handle(os.stdin);
    _, err := io.copy(stdout, stdin);
    if err != .None {
        fmt.eprintln("Failed to copy all data:", err);
    }
}
