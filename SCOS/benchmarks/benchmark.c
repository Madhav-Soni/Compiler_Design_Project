
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#define ARRAY_SIZE 1000

int main(int argc, char *argv[]) {

    // Runtime inputs
    uint64_t n = 50000000ULL;
    uint64_t seed = 12345ULL;

    if (argc > 1) {
        n = strtoull(argv[1], NULL, 10);
    }

    if (argc > 2) {
        seed = strtoull(argv[2], NULL, 10);
    }

    if (n == 0 || n > 200000000ULL) {
        fprintf(stderr, "Invalid iteration count\n");
        return 1;
    }

    // Runtime-dependent arithmetic workload
    uint64_t state = seed;
    uint64_t checksum = 0;

    for (uint64_t i = 0; i < n; i++) {

        state = state * 2862933555777941757ULL
                + 3037000493ULL;

        checksum += ((state >> 33) ^ state) & 0xFFFFULL;
    }

    // Repeated calculation workload
    int a = (int)(seed % 1000);
    int b = (int)((seed >> 8) % 1000);

    int c = (a * b) + (a * b);

    // Constant calculation workload
    int x = 5 * 10 + 20;

    // Array processing workload
    int arr[ARRAY_SIZE];

    for (int i = 0; i < ARRAY_SIZE; i++) {
        arr[i] = (int)(((uint64_t)i * 2 + seed) % 10000);
    }

    uint64_t array_sum = 0;

    for (int i = 0; i < ARRAY_SIZE; i++) {
        array_sum += (uint64_t)arr[i];
    }

    printf("Iterations: %llu\n", (unsigned long long)n);
    printf("Checksum: %llu\n", (unsigned long long)checksum);
    printf("Repeated calculation: %d\n", c);
    printf("Constant result: %d\n", x);
    printf("Array sum: %llu\n", (unsigned long long)array_sum);

    return 0;
}
