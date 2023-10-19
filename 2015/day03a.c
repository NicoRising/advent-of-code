#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

// (x, y) point
typedef struct Point {
    int x, y;
} Point;

// Binary tree node
typedef struct Node {
    Point p;
    struct Node *left, *right;
} Node;

// Construct a new node and return it
Node *make_node(const Point p);

// Attempt inserting a Point into a binary tree, and return false if it was already contained
bool insert(const Point p, Node *node);

// Recursively free memory allocated to a binary tree
void free_tree(Node *node);

void main() {
    FILE *input_file = fopen("input.txt", "r");

    if (input_file == NULL) {
        printf("Error opening file\n");
        exit(1);
    }

    Point curr_loc = {0, 0};
    Node *head = make_node(curr_loc);

    int visited = 1;
    char curr_char = fgetc(input_file);

    while (curr_char != '\n') {
        switch (curr_char) {
            case '>':
                curr_loc.x++;
                break;
            case '^':
                curr_loc.y++;
                break;
            case '<':
                curr_loc.x--;
                break;
            case 'v':
                curr_loc.y--;
        }

        visited += insert(curr_loc, head);
        curr_char = fgetc(input_file);
    }

    fclose(input_file);
    free_tree(head);

    printf("%d\n", visited);
}

Node *make_node(const Point p) {
    Node *node = malloc(sizeof(Node));

    if (node == NULL) {
        printf("Error allocating memory\n");
        exit(1);
    }

    node->p = p;
    node->left = NULL;
    node->right = NULL;

    return node;
}

bool insert(const Point p, Node *node) {
    int x_diff = node->p.x - p.x;

    if (x_diff < 0) {
        if (node->left != NULL) {
            return insert(p, node->left);
        } else {
            node->left = make_node(p);
        }
    } else if (x_diff > 0) {
        if (node->right != NULL) {
            return insert(p, node->right);
        } else {
            node->right = make_node(p);
        }
    } else { // Same x, now try y
        int y_diff = node->p.y - p.y;

        if (y_diff < 0) {
            if (node->left) {
                return insert(p, node->left);
            } else {
                node->left = make_node(p);
            }
        } else if (node->p.y>p.y) {
            if (node->right != NULL) {
                return insert(p, node->right);
            } else {
                node->right = make_node(p);
            }
        } else { // Point has been visited already
            return false;
        }
    }

    return true;
}

void free_tree(Node *node) {
    if (node->left != NULL) {
        free_tree(node->left);
    }

    if (node->right != NULL) {
        free_tree(node->right);
    }

    free(node);
}
