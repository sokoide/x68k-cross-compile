#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

void main() {
    printf("Hello X68000, I'm from Mac!\n");

    printf("sizeof(char)=%d\n", sizeof(char));
    printf("sizeof(int)=%d\n", sizeof(int));
    printf("sizeof(float)=%d\n", sizeof(float));
    printf("sizeof(double)=%d\n", sizeof(double));

    printf("sizeof(uint8_t)=%d\n", sizeof(uint8_t));
    printf("sizeof(uint16_t)=%d\n", sizeof(uint16_t));
    printf("sizeof(uint32_t)=%d\n", sizeof(uint32_t));
    // sizeof works fine for uint64_t
    printf("sizeof(uint64_t)=%d\n", sizeof(uint64_t));


    double d1 = 2.0*1000000;
    double d2 = 3.0*1000000*1000000;
    printf("d1=%lf\n", d1);
    printf("d2=%lf\n", d2);

    float f = 1.2345678901234567890f;
    double d = 1.2345678901234567890;

    printf("f = %.18f\n", f);
    printf("d = %.18f\n", d);

    // double - float diff
    printf("Difference: %.18f\n", d - f);

    uint8_t n1 = 0x12;
    uint16_t n2 = 0x1234;
    uint32_t n3 = 0x12345678;
    // uint64_t assignment doesn't cause an error
    uint64_t n4 = 0x123456789abcdef0;
    printf("n1: %08x\n", n1);
    printf("n2: %08x\n", n2);
    printf("n3: %08x\n", n3);

    // but the high 32bit is printed first
    printf("n4: %016llx\n", n4);
    // when you shift left, low 32bit appears
    printf("n4: <<8 %016llx\n", n4<<8);
    printf("n4: <<16 %016llx\n", n4<<16);
    printf("n4: <<32 %016llx\n", n4<<32);
    printf("n4: <<48 %016llx\n", n4<<48);
    printf("n4: >>8 %016llx\n", n4>>8);
    printf("n4: >>16 %016llx\n", n4>>16);
    printf("n4: >>32 %016llx\n", n4>>32);
    printf("n4: >>48 %016llx\n", n4>>48);
    printf("n4: %016llx\n", n4+2);

    // we shouldn't use uint64_t
}
