#include <stdio.h>
#include <stdlib.h>
#include <string.h>


void main() {
    FILE *input_file = fopen("input.txt", "r");

    if (input_file == NULL) {
        printf("Error opening file\n");
        exit(1);
    }

    int diff = 0;
    char line[64];

    while (fgets(line, 64, input_file) != NULL) {
        int length = strlen(line) - 1;
        int escaped_length = length + 2;

        // Remove newline
        line[length] = '\0';

        for (int idx = 0; idx < length; idx++) {
            if (line[idx] == '\\' || line[idx] == '"') {
                escaped_length++;
            }
        }
        
        diff += escaped_length - length;
    }

    fclose(input_file);
    printf("%d\n", diff);
}
