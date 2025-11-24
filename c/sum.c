// Sum the numbers, one number per line
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

int main()
{
    char buf[1024];
    double result = 0.0;
    while (fgets(buf, sizeof(buf), stdin) != NULL) {
        char* end = NULL;
        double value = strtod(buf, &end);
        if (end != buf) {
            result += value;
        }
    }
    if (result == round(result)) {
        printf("%ld\n", (long)result);
    } else {
        // Trim trailing .0000 before output
        char outbuf[64];
        int length = snprintf(outbuf, sizeof(outbuf), "%.8f", result);

        --length;
        while(outbuf[length] == '0') {
            outbuf[length] = '\0';
            --length;
        }
        if (outbuf[length] == '.') {
            outbuf[length] = '\0';
        }

        printf("%s\n", outbuf);
    }
    return 0;
}
