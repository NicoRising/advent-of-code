#include <openssl/evp.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Assign the MD5 hash of input to output
void md5_hash(const EVP_MD *md5, const char input[128], unsigned char output[EVP_MAX_MD_SIZE]);

// Determine if a given MD5 hash starts with 5 0s
bool valid_hash(const unsigned char hash[EVP_MAX_MD_SIZE]);

void main() {
    FILE *input_file = fopen("input.txt", "r");

    if (input_file == NULL) {
        printf("Error opening file\n");
        exit(1);
    }

    char key[64];
    fgets(key, sizeof(key), input_file);
    fclose(input_file);

    OpenSSL_add_all_digests();
    const EVP_MD *md5 = EVP_get_digestbyname("md5");

    if (md5 == NULL) {
        printf("Error getting MD5\n");
        exit(1);
    }

    key[strlen(key) - 1] = '\0'; // Remove newline

    int salt = 1;
    bool found_salt = false;

    while (!found_salt) {
        char salted_key[128];
        unsigned char hash[EVP_MAX_MD_SIZE];

        snprintf(salted_key, sizeof(salted_key), "%s%d", key, salt);
        md5_hash(md5, salted_key, hash); 
        
        if (valid_hash(hash)) {
            found_salt = true;
        } else {
            salt++;
        }
    }
    
    printf("%d\n", salt);
}

void md5_hash(const EVP_MD *md5, const char *input, unsigned char output[EVP_MAX_MD_SIZE]) {
    EVP_MD_CTX *md5_ctx = EVP_MD_CTX_new();

    EVP_DigestInit_ex(md5_ctx, md5, NULL);
    EVP_DigestUpdate(md5_ctx, input, strlen(input));
    EVP_DigestFinal_ex(md5_ctx, output, NULL);
    EVP_MD_CTX_free(md5_ctx);

    EVP_cleanup();
}

bool valid_hash(const unsigned char hash[EVP_MAX_MD_SIZE]) {
    return hash[0] == 0 && hash[1] == 0 && hash[2] < 16;
}
