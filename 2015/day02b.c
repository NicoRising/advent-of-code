#include <stdio.h>

void main() {
    FILE *input = fopen("input.txt", "r");
    int ribbon = 0;
    while (!feof(input)) {
        int l, w, h;
        fscanf(input, "%dx%dx%d", &l, &w, &h);
        ribbon += (l + w < w + h ? l + w < h + l ? l + w : h + l : w + h < h + l ? w + h : h + l) * 2;
        ribbon += l * w * h;
    }
    printf("%d\n", ribbon);
}