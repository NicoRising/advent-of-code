#include <stdio.h>

void main() {
    FILE *input = fopen("input.txt", "r");
    int area = 0;
    while (!feof(input)) {
        int l, w, h;
        fscanf(input, "%dx%dx%d", &l, &w, &h);
        area += l * w * 2 + w * h * 2 + h  * l * 2;
        area += l * w < w * h ? l * w < h * l ? l * w : h * l : w * h < h * l ? w * h : h * l; // 200 IQ
    }
    printf("%d\n", area);
}