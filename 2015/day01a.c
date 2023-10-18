#include <stdio.h>

void main() {
    FILE *input = fopen("input.txt", "r");

    int floor = 0;
    int current = fgetc(input);

    while (current != '\n') {
        floor += current == 40 ? 1 : -1;
        current = fgetc(input);
    }

    printf("%d\n", floor);
}

