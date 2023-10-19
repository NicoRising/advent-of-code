#include <stdio.h>
#include <stdlib.h>

void main() {
    FILE *input = fopen("input.txt", "r");

    if (input == NULL) {
        printf("Error opening file\n");
        exit(1);
    }

    int floor = 0;
    int current = fgetc(input);

    while (current != '\n') {
        floor += current == '(' ? 1 : -1;
        current = fgetc(input);
    }

    fclose(input);
    printf("%d\n", floor);
}
