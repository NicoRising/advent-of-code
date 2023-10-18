#include <stdio.h>

void main() {
    FILE *input = fopen("input.txt", "r");

    int floor = 0;
    int step = 0;
    int current = fgetc(input);

    while (floor >= 0) {
        floor += (current == 40) ? 1 : -1;
        step++;

        current = fgetc(input);
    }

    printf("%d\n", step);
}

