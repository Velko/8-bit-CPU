#include <stdint.h>
#include <stdio.h>
/***
  X ABC Algorithm Random Number Generator for 8-Bit Devices
  https://www.electro-tech-online.com/threads/ultra-fast-pseudorandom-number-generator-for-8-bit.124249/
  Not safe for cryptographic use!

  2025-08-04: Modified to use rotate
***/

static uint8_t a, b, c, x;

/* return 8-bit pseudorandom number */
uint8_t rnd8() {
  x++;
  a = (a ^ c) ^ x;
  b = b + a;
  c = (c + ((b >> 1) | (b << 7))) ^ a;
  return c;
}

/* Add entropy into the state */
void init_rng(uint8_t s1, uint8_t s2, uint8_t s3) {
  /* XOR new entropy into key state */
  a ^= s1;
  b ^= s2;
  c ^= s3;
  rnd8();
}

uint8_t nibble_swap(uint8_t x) {
    return (x << 4) | (x >> 4);
}

uint8_t reduce_to_38_fast(uint8_t random_8bit) {
    uint8_t swap = nibble_swap(random_8bit);
    uint8_t x_gt_4 = swap & 0x0F;

    // Calculate pieces using minimal steps
    uint8_t x_gt_6 = x_gt_4 >> 2;
    uint8_t x_gt_7 = x_gt_6 >> 1; // Just 1 extra shift!
    uint8_t x_gt_3 = (x_gt_4 << 1) | (swap >> 7);

    return x_gt_3 + x_gt_6 + x_gt_7;
}

int main() {
    /* Initialize with some arbitrary values */
    init_rng(0x01, 0x02, 0x03);

    /* Generate and print some random numbers */
    for (int i = 0; i < 256; i++) {
        uint8_t r = rnd8();
        uint8_t reduced = reduce_to_38_fast(r);
        printf("\033[1;31mh %02x\n\033[0m", reduced);
    }

    return 0;
}
