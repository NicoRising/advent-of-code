#include <openssl/md5.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Determine if a given MD5 hash starts with 6 0s
bool valid_hash(unsigned char hash[MD5_DIGEST_LENGTH]);

void main() {
    FILE *input_file = fopen("input.txt", "r");

    if (input_file == NULL) {
        printf("Error opening file\n");
        exit(1);
    }

    char key[64];
    fgets(key, sizeof(key), input_file);
    fclose(input_file);

    key[strlen(key) - 1] = '\0'; // Remove newline

    int salt = 1;
    bool found_salt = false;

    while (!found_salt) {
        char salted_key[128];
        unsigned char hash[MD5_DIGEST_LENGTH];

        snprintf(salted_key, sizeof(salted_key), "%s%d", key, salt);
    
        MD5_CTX md5_context;
        MD5_Init(&md5_context);

        MD5_Update(&md5_context, salted_key, strlen(salted_key));
        MD5_Final(hash, &md5_context);
        
        if (valid_hash(hash)) {
            found_salt = true;
        } else {
            salt++;
        }
    }
    
    printf("%d\n", salt);
}

bool valid_hash(unsigned char hash[MD5_DIGEST_LENGTH]) {
    return hash[0] == 0 && hash[1] == 0 && hash[2] == 0;
}
