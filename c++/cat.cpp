#include <iostream>
int main() {
    int exit_code = 0; // success
    char buf[1024];
    for(;;)
    {
        std::cin.read(buf, sizeof(buf));
        size_t count = std::cin.gcount();
        if(count != 0) {
            std::cout.write(buf, count);
            if(!std::cout) {
                std::cerr << "Failed to write to standard output\n";
                exit_code = 1;
                break;
            }
        } else {
            if(std::cin.bad()) {
                std::cerr << "Failed to read from standard input\n";
                exit_code = 1;
                break;
            }
            break;
        }
    }
    return exit_code;
}
