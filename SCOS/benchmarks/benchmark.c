#include <stdio.h>
#include <stdlib.h>

#define N 10000000

int main() {
    long long sum = 0;

    // Loop optimization opportunity
    for (int i = 0; i < N; i++) {
        sum += i;
    }

    // Repeated calculation opportunity
    int a = 10;
    int b = 20;
    int c = (a * b) + (a * b);

    // Constant calculation opportunity
    int x = 5 * 10 + 20;

    // Array processing
    int arr[1000];

    for (int i = 0; i < 1000; i++) {
        arr[i] = i * 2;
    }

    long long array_sum = 0;

    for (int i = 0; i < 1000; i++) {
        array_sum += arr[i];
    }

    printf("Loop sum: %lld\n", sum);
    printf("Repeated calculation: %d\n", c);
    printf("Constant result: %d\n", x);
    printf("Array sum: %lld\n", array_sum);

    return 0;
}
