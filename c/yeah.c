//
// Australian language translator
//
// gcc yeah.c -o yeah
// Usage: ./yeah nah
//        ./yeah nah yeah

#include <stdio.h>

int main(int argc, char** argv)
{
    const char* message = argv[argc - 1];
    puts(message);
    return 0;
}
