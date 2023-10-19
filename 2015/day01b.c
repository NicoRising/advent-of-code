#include <stdio.h>
#include <stdlib.h>

void main() {
    FILE *input_file = fopen("input.txt", "r");

    if (input_file == NULL) {
        printf("Error opening file\n");
        exit(1);
    }

    int floor = 0;
    int step = 0;
    int curr_char = fgetc(input_file);

    while (floor >= 0) {
        floor += curr_char == '(' ? 1 : -1;
        step++;

        curr_char = fgetc(input_file);
    }

    fclose(input_file);
    printf("%d\n", step);
}
