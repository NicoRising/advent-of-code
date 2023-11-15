#include <regex.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

void main() {
    FILE *input_file = fopen("input.txt", "r");

    if (input_file == NULL) {
        printf("Error opening file\n");
        exit(1);
    }

    regex_t repeat_section, repeat_with_gap;
    int reg_out;
    char err_buffer[64];

    if (reg_out = regcomp(&repeat_section, "(..).*\\1", REG_EXTENDED)) {
        regerror(reg_out, &repeat_section, err_buffer, 64);
        printf("Error compiling repeat section regex: %s\n", err_buffer);
        exit(1);
    }

    if (reg_out = regcomp(&repeat_with_gap, "(.).\\1", REG_EXTENDED)) {
        regerror(reg_out, &repeat_with_gap, err_buffer, 64);
        printf("Error compiling repeat with gap regex: %s\n", err_buffer);
        exit(1);
    }

    int nice = 0;

    while (!feof(input_file)) {
        char string[64];
        fscanf(input_file, "%s\n", string);
        
        bool has_repeat_section = regexec(&repeat_section, string, 0, NULL, 0) == 0;
        bool has_repeat_with_gap = regexec(&repeat_with_gap, string, 0, NULL, 0) == 0;

        if (has_repeat_section && has_repeat_with_gap) {
            nice++;
        } 
    }

    printf("%d\n", nice);
}
