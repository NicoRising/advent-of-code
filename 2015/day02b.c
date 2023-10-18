#include <stdio.h>

void main() {
    FILE *input = fopen("input.txt", "r");

    int ribbon = 0;

    while (!feof(input)) {
        int l, w, h;
        fscanf(input, "%dx%dx%d\n", &l, &w, &h);

        int lw = l + w;
        int lh = l + h;
        int wh = w + h;

        ribbon += (lw < lh ? lw < wh ? lw : wh : lh < wh ? lh : wh) * 2;
        ribbon += l * w * h;
    }

    printf("%d\n", ribbon);
}
