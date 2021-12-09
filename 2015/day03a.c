#include <stdio.h>
#include <stdlib.h>

typedef struct point {
    int x, y;
} point;

typedef struct node {
    point p;
    struct node *left, *right;
} node;

int insert(node *head, point p); // Returns zero if the point was already stored,  otherwise stores and returns non-zero
void place(node *n, point p);
void display(node *n);

int main() {
    FILE *input = fopen("input.txt", "r");
    point location;
    location.x = 0;
    location.y = 0;
    node *head = malloc(sizeof(node));
    head->p = location;
    head->left = NULL;
    head->right = NULL;
    int visited = 1;
    char current = fgetc(input);
    while (!feof(input)) {
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
        if (insert(head, location)) {
            visited++;
        }
        current = fgetc(input);
    }
    printf("%d\n", visited);
}

int insert(node *head, point p) {
    if (head->p.x<p.x) {
        if (head->right) {
            return insert(head->right, p);
        } else {
            head->right = malloc(sizeof(node));
            place(head->right, p);
        }
    } else if (head->p.x>p.x) {
        if (head->left) {
            return insert(head->left, p);
        } else {
            head->left = malloc(sizeof(node));
            place(head->left, p);
        }
    } else {
        if (head->p.y<p.y) {
            if (head->right) {
                return insert(head->right, p);
            } else {
                head->right = malloc(sizeof(node));
                place(head->right, p);
            }
        } else if (head->p.y>p.y) {
            if (head->left) {
                return insert(head->left, p);
            } else {
                head->left = malloc(sizeof(node));
                place(head->left, p);
            }
        } else {
            return 0;
        }
    }
    return 1;
}

void place(node *n, point p) {
    n->p = p;
    n->left = NULL;
    n->right = NULL;
}

void display(node *head) {
    printf("(%d, %d)\n", head->p.x, head->p.y);
    if (head->left) {
        printf("L: (%d, %d)\n", head->left->p.x, head->left->p.y);
        display(head->left);
    }
    if (head->right) {
        printf("R: (%d, %d)\n", head->right->p.x, head->right->p.y);
        display(head->right);
    }
}