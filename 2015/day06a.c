#include <regex.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void main() {
    FILE *input_file = fopen("input.txt", "r");

    if (input_file == NULL) {
        printf("Error opening file\n");
        exit(1);
    }

    regex_t mode_regex;
    int reg_out;

    if (reg_out = regcomp(&mode_regex, "turn on|turn off|toggle", REG_EXTENDED)) {
        char err_buffer[64];
        regerror(reg_out, &mode_regex, err_buffer, 64);
        printf("Error compiling mode regex: %s\n", err_buffer);
        exit(1);
    }

    bool grid[1000][1000] = {false};
    char line[64];

    while (fgets(line, 64, input_file) != NULL) {
        regmatch_t mode_groups[1];
        regexec(&mode_regex, line, 1, mode_groups, 0);

        int start = mode_groups[0].rm_so;
        int end = mode_groups[0].rm_eo;

        char mode[64];
        int idx = 0;

        for (; idx < end - start; idx++) {
            mode[idx] = line[start + idx];
        }

        mode[idx] = '\0';

        char *rest = &line[idx + 1];

        int x1, y1, x2, y2;
        sscanf(rest, "%d,%d through %d,%d", &x1, &y1, &x2, &y2);

        for (int x = x1; x <= x2; x++) {
            for (int y = y1; y <= y2; y++) {
                if (strcmp(mode, "turn on") == 0) {
                    grid[x][y] = true;
                } else if (strcmp(mode, "turn off") == 0) {
                    grid[x][y] = false;
                } else if (strcmp(mode, "toggle") == 0) {
                    grid[x][y] = !grid[x][y];
                }
            }
        }
    }

    fclose(input_file);
    regfree(&mode_regex);

    int num_on = 0;

    for (int x = 0; x < 1000; x++) {
        for (int y = 0; y < 1000; y++) {
            num_on += grid[x][y];
        }
    }

    printf("%d\n", num_on);
}
