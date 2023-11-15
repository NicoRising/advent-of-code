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

    regex_t three_vowels, double_letter, bad_pairs;
    int reg_out;
    char err_buffer[64];

    if (reg_out = regcomp(&three_vowels, "([aeiou].*){3,}", REG_EXTENDED)) {
        regerror(reg_out, &three_vowels, err_buffer, 64);
        printf("Error compiling three vowels regex: %s\n", err_buffer);
        exit(1);
    }

    if (reg_out = regcomp(&double_letter, "(.)\\1", REG_EXTENDED)) {
        regerror(reg_out, &double_letter, err_buffer, 64);
        printf("Error compiling double letter regex: %s\n", err_buffer);
        exit(1);
    }

    if (reg_out = regcomp(&bad_pairs, "(ab|cd|pq|xy)", REG_EXTENDED)) {
        regerror(reg_out, &bad_pairs, err_buffer, 64);
        printf("Error compiling bad pairs regex: %s\n", err_buffer);   
        exit(1);
    }

    int nice = 0;

    while (!feof(input_file)) {
        char string[64];
        fscanf(input_file, "%s\n", string);
        
        bool has_three_vowels = regexec(&three_vowels, string, 0, NULL, 0) == 0;
        bool has_double_letter = regexec(&double_letter, string, 0, NULL, 0) == 0;
        bool has_bad_pair = regexec(&bad_pairs, string, 0, NULL, 0) == 0;

        if (has_three_vowels && has_double_letter && !has_bad_pair) {
            nice++;
        } 
    }

    fclose(input_file);
    regfree(&three_vowels);
    regfree(&double_letter);
    regfree(&bad_pairs);

    printf("%d\n", nice);
}
