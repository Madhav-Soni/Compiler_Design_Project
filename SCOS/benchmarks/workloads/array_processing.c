
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int main(int argc, char *argv[]) {

    uint64_t n = 1000000ULL;
    uint64_t seed = 12345ULL;

    if (argc > 1)
        n = strtoull(argv[1], NULL, 10);

    if (argc > 2)
        seed = strtoull(argv[2], NULL, 10);

    if (n == 0 || n > 10000000ULL) {
        fprintf(stderr, "Invalid array size\n");
        return 1;
    }

    uint32_t *arr = malloc((size_t)n * sizeof(*arr));

    if (arr == NULL) {
        fprintf(stderr, "Memory allocation failed\n");
        return 1;
    }

    uint64_t state = seed;

    // Initialize the array with runtime-dependent values
    for (uint64_t i = 0; i < n; i++) {

        state = state * 2862933555777941757ULL
                + 3037000493ULL;

        arr[i] = (uint32_t)((state >> 32) & 0xFFFF);
    }

    // Transform array elements
    for (uint64_t i = 0; i < n; i++) {

        arr[i] = (arr[i] * 3U + (uint32_t)(i & 255U))
                 & 0xFFFFU;
    }

    // Calculate checksum
    uint64_t checksum = 0;

    for (uint64_t i = 0; i < n; i++) {
        checksum += arr[i];
    }

    printf("Workload: Array Processing\n");
    printf("Array elements: %llu\n", (unsigned long long)n);
    printf("Checksum: %llu\n", (unsigned long long)checksum);

    free(arr);

    return 0;
}
