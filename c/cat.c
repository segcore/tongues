#include <stdio.h>
int main() {
    int exit_code = 0; // success
    char buf[1024];
    for(;;) {
        size_t count = fread(buf, sizeof(char), sizeof(buf), stdin);
        if(count > 0) {
            size_t written = fwrite(buf, sizeof(char), count, stdout);
            if(written != count) {
                fprintf(stderr, "Failed to write to stdout\n");
                exit_code = 1;
                break;
            }
        } else {
            if(ferror(stdin)) {
                fprintf(stderr, "Failed to read from stdin\n");
                exit_code = 1;
            }
            break;
        }
    }
    return exit_code;
}
