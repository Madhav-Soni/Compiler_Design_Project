
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int main(int argc, char *argv[]) {

    uint64_t n = 50000000ULL;
    uint64_t seed = 12345ULL;

    if (argc > 1)
        n = strtoull(argv[1], NULL, 10);

    if (argc > 2)
        seed = strtoull(argv[2], NULL, 10);

    if (n == 0 || n > 200000000ULL) {
        fprintf(stderr, "Invalid iteration count\n");
        return 1;
    }

    uint64_t state = seed;
    uint64_t checksum = 0;

    for (uint64_t i = 0; i < n; i++) {

        state = state * 2862933555777941757ULL
                + 3037000493ULL;

        checksum += ((state >> 33) ^ state) & 0xFFFFULL;
    }

    printf("Workload: Arithmetic\n");
    printf("Iterations: %llu\n", (unsigned long long)n);
    printf("Checksum: %llu\n", (unsigned long long)checksum);

    return 0;
}
