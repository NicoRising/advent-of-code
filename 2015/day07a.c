#include <ctype.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Converts a wire to its natural representation. Assumes max of 2 letters
int wire_to_int(char *wire);

void main() {
    FILE *input_file = fopen("input.txt", "r");

    if (input_file == NULL) {
        printf("Error opening file\n");
        exit(1);
    }

    bool signaled[702] = { false };
    unsigned short signals[702];

    // Keep looping through the file until wire a gets signaled
    while (!signaled[0]) {
        char line[64];

        while (fgets(line, 64, input_file) != NULL) {
            int space_count = 0;

            for (int idx = 0; idx < strlen(line); idx++) {
                space_count += line[idx] == ' ';
            }

            char out[8];
            int out_idx;
            unsigned short out_sig;
            
            if (space_count == 2) {
                char a[8];
                sscanf(line, "%s -> %s\n", &a, out);

                out_idx = wire_to_int(out);
                if (signaled[out_idx]) {
                    continue;
                }

                if (isdigit(a[0])) {
                    out_sig = atoi(a);
                } else {
                    int a_idx = wire_to_int(a);

                    if (!signaled[a_idx]) {
                        continue;
                    }

                    out_sig = signals[a_idx];
                }
            } else if (space_count == 3) {
                char a[8];
                sscanf(line, "NOT %s -> %s\n", &a, out);

                out_idx = wire_to_int(out);
                if (signaled[out_idx]) {
                    continue;
                }

                if (isdigit(a[0])) {
                    out_sig = ~atoi(a);
                } else {
                    int a_idx = wire_to_int(a);

                    if (!signaled[a_idx]) {
                        continue;
                    }

                    out_sig = ~signals[a_idx];
                }
            } else if (space_count == 4) {
                char a[8], op[8], b[8];
                sscanf(line, "%s %s %s -> %s\n", &a, &op, &b, &out);

                out_idx = wire_to_int(out);
                if (signaled[out_idx]) {
                    continue;
                }

                unsigned short a_sig, b_sig;

                if (isdigit(a[0])) {
                    a_sig = atoi(a);
                } else {
                    int a_idx = wire_to_int(a);

                    if (!signaled[a_idx]) {
                        continue;
                    }

                    a_sig = signals[a_idx];
                }

                if (isdigit(b[0])) {
                    b_sig = atoi(b);
                } else {
                    int b_idx = wire_to_int(b);

                    if (!signaled[b_idx]) {
                        continue;
                    }

                    b_sig = signals[b_idx];
                }

                if (strcmp(op, "AND") == 0) {
                    out_sig = a_sig & b_sig;
                } else if (strcmp(op, "OR") == 0) {
                    out_sig = a_sig | b_sig;
                } else if (strcmp(op, "LSHIFT") == 0) {
                    out_sig = a_sig << b_sig;
                } else if (strcmp(op, "RSHIFT") == 0) {
                    out_sig = a_sig >> b_sig;
                } else {
                    printf("Unknown binary operation: %s\n", op);
                    exit(1);
                }
            } else {
                printf("Unknown space count on line: %s\n", line);
                exit(1);
            }

            signaled[out_idx] = true;
            signals[out_idx] = out_sig;
        }

        rewind(input_file);
    }

    fclose(input_file);
    printf("%hu\n", signals[0]);
}

int wire_to_int(char *wire) {
    if (strlen(wire) == 1) {
        return wire[0] - 97;
    } else if (strlen(wire) == 2) {
        // 96 accounts for wires of length 1
        return (wire[0] - 96) * 26 + wire[1] - 97;
    } else {
        printf("Expected wire to be of length 1 or 2, was not: %s\n", wire);
        exit(1);
    }
}
