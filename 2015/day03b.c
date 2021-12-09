#include <stdio.h>
#include <stdlib.h>

typedef struct point {
    int x, y;
} point;

typedef struct node {
    point p;
    struct node *left, *right;
} node;

int insert(node *head, point p); // Returns zero if the point was already stored, otherwise stores and returns non-zero
int compare(point a, point b);
void display(node *head);

void main() {
    FILE *input = fopen("input.txt", "r");
    point location, roboLocation;
    location.x = 0;
    location.y = 0;
    roboLocation.x = 0;
    roboLocation.y = 0;
    node *head = malloc(sizeof(node));
    head->p = location;
    head->left = NULL;
    head->right = NULL;
    int total = 0;
    int visited = 1;
    char current = fgetc(input);
    while (!feof(input)) {
        if (!(total % 2)) {
            switch(current) {
                case '>':
                    location.x++;
                    break;
                case '<':
                    location.x--;
                    break;
                case '^':
                    location.y++;
                    break;
                case 'v':
                    location.y--;
            }
            if (insert(head,location)) {
                visited++;
            }
        } else {
            switch(current) {
                case '>':
                    roboLocation.x++;
                    break;
                case '<':
                    roboLocation.x--;
                    break;
                case '^':
                    roboLocation.y++;
                    break;
                case 'v':
                    roboLocation.y--;
            }
            if (insert(head,roboLocation)) {
                visited++;
            }
        }
        current = fgetc(input);
        total++;
    }
    printf("%d\n" ,visited);
}

int insert(node *head, point p){
    int comp = compare(p, head->p);
    if (comp < 0) {
        if (head->left) {
            return insert(head->left, p);
        }
        head->left = malloc(sizeof(node));
        head->left->p = p;
        head->left->left = NULL;
        head->left->right = NULL;
    } else if (comp > 0) {
        if (head->right) {
            return insert(head->right, p);
        }
        head->right = malloc(sizeof(node));
        head->right->p = p;
        head->right->left = NULL;
        head->right->right = NULL;
    } else {
        return 0;
    }
    return 1;
}

int compare(point a, point b){
    if (a.x != b.x) {
        return a.x - b.x;
    }
    return a.y - b.y;
}

void display(node *head){
    printf("(%d,%d)\n", head->p.x, head->p.y);
    if (head->left) {
        printf("L: (%d,%d)\n", head->left->p.x, head->left->p.y);
        display(head->left);
    }
    if (head->right) {
        printf("R: (%d,%d)\n", head->right->p.x, head->right->p.y);
        display(head->right);
    }
}