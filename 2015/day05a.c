#include <stdio.h>
#include <stdlib.h>

void main() {
    FILE *input = fopen("input.txt", "r");
    int nice = 0;
    while(!feof(input)){
        char *word = malloc(sizeof(char) * 255);
        fgets(word, 255, input);
        char last = '\0';
        int valid = 0;
        int vowels = 0;
        int index = 0;
        while (*(word + index) != '\0') {
            char current= *(word + index++);
            vowels += (current == 'a') + (current == 'e') + (current == 'i') + (current == 'o') + (current == 'u');
            if (last == current) {
                valid = 1;
            }
            if (last == 'a' && current == 'b' || last == 'c' && current == 'd' || last == 'p' && current == 'q' || last == 'x' && current == 'y') {
                valid = 0;
                break;
            }
            last = current;
        }
        nice += valid && vowels >= 3;
    }
    printf("%d\n", nice);
}