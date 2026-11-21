
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

static uint64_t transform_a(uint64_t x) {
    return (x * 31ULL + 17ULL) ^ (x >> 7);
}

static uint64_t transform_b(uint64_t x) {
    return (x * 13ULL + 29ULL) ^ (x >> 11);
}

static uint64_t transform_c(uint64_t x) {
    return (x * 7ULL + 43ULL) ^ (x >> 13);
}

static uint64_t transform_d(uint64_t x) {
    return (x * 19ULL + 53ULL) ^ (x >> 5);
}

int main(int argc, char *argv[]) {

    uint64_t n = 10000000ULL;
    uint64_t seed = 12345ULL;

    if (argc > 1)
        n = strtoull(argv[1], NULL, 10);

    if (argc > 2)
        seed = strtoull(argv[2], NULL, 10);

    if (n == 0 || n > 50000000ULL) {
        fprintf(stderr, "Invalid iteration count\n");
        return 1;
    }

    uint64_t state = seed;
    uint64_t checksum = 0;

    for (uint64_t i = 0; i < n; i++) {

        uint64_t a = transform_a(state);
        uint64_t b = transform_b(a);
        uint64_t c = transform_c(b);
        uint64_t d = transform_d(c);

        state = d ^ (i + seed);

        checksum += state;
    }

    printf("Workload: Function Heavy\n");
    printf("Iterations: %llu\n", (unsigned long long)n);
    printf("Checksum: %llu\n", (unsigned long long)checksum);

    return 0;
}
