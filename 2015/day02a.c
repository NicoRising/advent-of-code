#include <stdio.h>

void main() {
    FILE *input = fopen("input.txt", "r");

    int area = 0;

    while (!feof(input)) {
        int l, w, h;
        fscanf(input, "%dx%dx%d\n", &l, &w, &h);

        int lw = l * w;
        int lh = l * h;
        int wh = w * h;

        area += lw * 2 + lh * 2 + wh * 2;
        area += lw < lh ? lw < wh ? lw : wh : lh < wh ? lh : wh;
    }

    printf("%d\n", area);
}

