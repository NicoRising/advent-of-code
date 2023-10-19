#include <stdio.h>
#include <stdlib.h>

void main() {
    FILE *input_file = fopen("input.txt", "r");

    if (input_file == NULL) {
        printf("Error opening file\n");
        exit(1);
    }

    int ribbon_len = 0;

    while (!feof(input_file)) {
        int l, w, h;
        fscanf(input_file, "%dx%dx%d\n", &l, &w, &h);

        int lw = l + w;
        int lh = l + h;
        int wh = w + h;

        ribbon_len += (lw < lh ? lw < wh ? lw : wh : lh < wh ? lh : wh) * 2;
        ribbon_len += l * w * h;
    }

    fclose(input_file);
    printf("%d\n", ribbon_len);
}
