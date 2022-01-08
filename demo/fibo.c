#include <stdio.h>
#include <stdint.h>

/* Reference algorithm for fibo32 */

int main()
{
    uint32_t a, b;

    a = 0;
    b = 1;

    printf("%u\n", a);
    printf("%u\n", b);

    while (1)
    {
        a += b;
        if (a < b) break;
        printf("%u\n", a);

        b += a;
        if (b < a) break;
        printf("%u\n", b);
    }


    return 0;
}

