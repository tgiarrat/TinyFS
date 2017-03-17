#include "libDisk.h"

int print_hex(char *pre, unsigned char *bytes, int size) {
    printf("%s", pre);
    for (int i = 0; i < size; i++) {
        printf("%02x", bytes[i]);
    }
    printf("\n");
    return 0;
}

// Generates a master key file
// EncryptedKey||PBKDFSalt||iv
int generateMasterKey(char *file, char *password, unsigned char *key, unsigned char *iv) {
    if (key == NULL)  {
        unsigned char keyArray[AES_KEY_SIZE];
        key = keyArray;
        generateRandomData(keyArray, AES_KEY_SIZE);
    }

    print_hex("GENERATED KEY:: ", key, AES_KEY_SIZE);
    if (iv == NULL)  {
        unsigned char ivArray[AES_IV_SIZE];
        iv = ivArray;
        generateRandomData(ivArray, AES_IV_SIZE);
    }

    unsigned char salt[SALT_SIZE];
    generateRandomData(salt, SALT_SIZE);

    unsigned char masterKeyMaterial[MASTER_KEY_MATERIAL_SIZE];

    print_hex("iv: ", iv, AES_IV_SIZE);
    print_hex("salt: ", salt, SALT_SIZE);
    // appending encrypted key
    aesXorMasterKey(key, password, salt, iv, masterKeyMaterial);

    // appending IV
    memcpy(masterKeyMaterial+AES_KEY_SIZE, iv, AES_IV_SIZE);

    // appending salt
    memcpy(masterKeyMaterial+AES_KEY_SIZE+AES_IV_SIZE, salt, SALT_SIZE);

    FILE *fp = fopen(file, "w");

    fwrite(masterKeyMaterial, MASTER_KEY_MATERIAL_SIZE, sizeof(unsigned char), fp);
    fclose(fp);

    return SUCCESS;
}

// get the MasterKey and the iv
int extractMasterKey(char *file, char *password, unsigned char *keyOut, unsigned char *ivOut) {
    FILE *fp = fopen(file, "r");

    unsigned char masterKeyMaterial[MASTER_KEY_MATERIAL_SIZE];
    fread(masterKeyMaterial, MASTER_KEY_MATERIAL_SIZE, sizeof(unsigned char), fp);
    fclose(fp);

    unsigned char keyEncrypted[AES_KEY_SIZE];
    memcpy(keyEncrypted, masterKeyMaterial, AES_KEY_SIZE);

    // extracting the iv
    memcpy(ivOut, masterKeyMaterial+AES_KEY_SIZE, AES_IV_SIZE);
    print_hex("iv: ", ivOut, AES_IV_SIZE);

    unsigned char salt[SALT_SIZE];
    memcpy(salt, masterKeyMaterial+AES_KEY_SIZE+AES_IV_SIZE, SALT_SIZE);
    print_hex("salt: ", salt, SALT_SIZE);

    // extracting the masterKey
    return aesXorMasterKey(keyEncrypted, password, salt, ivOut, keyOut);
}

// pass in the password salt and iv and get out the master key
int aesXorMasterKey(unsigned char *masterKeyIn, char *password, unsigned char *salt, unsigned char *iv, unsigned char *masterKeyOut) {
    unsigned char flattenedKey[AES_KEY_SIZE];
    PBKDF(password, salt, flattenedKey);

    print_hex("flatkey: ", flattenedKey, AES_KEY_SIZE);

    unsigned char *ivTmp = malloc(AES_IV_SIZE);
    memcpy(ivTmp, iv, AES_IV_SIZE);
    aes128Ctr(flattenedKey, ivTmp, masterKeyIn, masterKeyOut, AES_KEY_SIZE);

    return SUCCESS;
}

// Argon2
int PBKDF(char *password, unsigned char *salt, unsigned char *result) {
    if (crypto_pwhash
            (result, AES_KEY_SIZE, password, strlen(password), salt,
             crypto_pwhash_OPSLIMIT_INTERACTIVE, crypto_pwhash_MEMLIMIT_INTERACTIVE,
             crypto_pwhash_ALG_DEFAULT) != 0) {
        /* out of memory */
    }

    return SUCCESS;
}

void generateRandomData(unsigned char *data, int length) {
    FILE *fp;
    fp = fopen("/dev/urandom", "r");
    fread(data, 1, length, fp);
    fclose(fp);
}

// decrypts master key with PBKDF(oldPassword, salt)
// encrypts master key with PBKDF(newPassword, salt)
int changePassword(char *oldFile, char *newFile, char *oldPassword, char *newPassword) {
    unsigned char key[AES_KEY_SIZE];
    unsigned char iv[AES_IV_SIZE];
    extractMasterKey(oldFile, oldPassword, key, iv);
    generateMasterKey(newFile, newPassword, key, iv);
    return SUCCESS;
}

int mountDisk(char *filename, int nBytes, char *password, char *masterKeyFile) {
    int mount_idx;
    for (mount_idx = 0; disks[mount_idx] != NULL && mount_idx != MAX_DISKS; ++mount_idx);

    if (mount_idx == MAX_DISKS) {
        return -1;
    }

    disks[mount_idx] = malloc(sizeof(disk_ctx));
    disk_ctx *disk = disks[mount_idx];

    disk->fp = fopen(filename, "r+");
    if (disk->fp == NULL) {
        disk->fp = fopen(filename, "w");
        disk->fp = fopen(filename, "r+");
    }


    disk->key = malloc(AES_KEY_SIZE);
    disk->iv = malloc(AES_KEY_SIZE);

    // protect key from being written to disk
    // sodium_mlock(disk->key, AES_KEY_SIZE);

    extractMasterKey(masterKeyFile, password, disk->key, disk->iv);
    print_hex("UNLOCKED KEY:: ", disk->key, AES_KEY_SIZE);

    // creating a disk for the first time
    if (nBytes > 0) {
        unsigned char *zero_block[BLOCK_SIZE];
        // write the entire disk with encrypted blank data
        if (nBytes % BLOCK_SIZE != 0) {
            printf("nBytes is not an integral number of blocksize\n");
        }

        int blocks = nBytes / BLOCK_SIZE;
        disk->size = nBytes;

        int writeStatus;
        for (int block = 0; block < blocks; block++) {
            if ((writeStatus = writeBlock(mount_idx, block, zero_block))) {
                printf("ERROR writing blocks, status: %d\n", writeStatus);
            }
        }
    } else {
        fseek(disk->fp, 0L, SEEK_END);
        size_t size = ftell(disk->fp);
        rewind(disk->fp);

        disk->size = size;
    }

    return mount_idx;
}

int unmountDisk(int disk) {
    disk_ctx *ctx;
    if (!(ctx = disks[disk])) {
        return DISK_NOT_FOUND;
    } else {
        //fclose(ctx->fp);
        // zero out the key so that its not sitting around in memory
        memset(ctx->key, 0, AES_KEY_SIZE);
        memset(ctx->iv, 0, AES_IV_SIZE);

        free(ctx->key);
        free(ctx->iv);
        free(ctx);
    }
    disks[disk] = NULL;

    return 0;
}

int readBlock(int disk, int bNum, void *plaintext) {
    disk_ctx *ctx;
    if (!(ctx = disks[disk])) {
        return DISK_NOT_FOUND;
    }
    if (bNum >= ctx->size / BLOCK_SIZE || bNum < 0) {
        return ENCRYPTION_ERROR;
    }

    unsigned char ciphertext[BLOCK_SIZE];
    fseek(ctx->fp, bNum * BLOCK_SIZE, SEEK_SET);
    fread(ciphertext, sizeof(unsigned char), BLOCK_SIZE, ctx->fp);

    if (aesCtrXorBlock(ciphertext, plaintext, ctx->key, ctx->iv, bNum))
        return ENCRYPTION_ERROR;

    return SUCCESS;
}

int writeBlock(int disk, int bNum, void *plaintext) {
    disk_ctx *ctx;
    if (!(ctx = disks[disk])) {
        return DISK_NOT_FOUND;
    }

    unsigned char ciphertext[BLOCK_SIZE];
    if (aesCtrXorBlock(plaintext, ciphertext, ctx->key, ctx->iv, bNum))
        return ENCRYPTION_ERROR;

    fseek(ctx->fp, bNum * BLOCK_SIZE, SEEK_SET);
    fwrite(ciphertext, sizeof(unsigned char), BLOCK_SIZE, ctx->fp);
    fflush(ctx->fp);

    return SUCCESS;
}

statusCode aesCtrXorBlock(unsigned char *inputBytes, unsigned char *outputBytes, unsigned char *key, unsigned char *iv, int bNum) {

    // xor the bNum with the iv
    unsigned char ivXord[AES_IV_SIZE];
    memcpy(ivXord, iv, AES_IV_SIZE);
    ivXord[0] ^= (bNum & 0xFF000000) >> 24;
    ivXord[1] ^= (bNum & 0x00FF0000) >> 16;
    ivXord[2] ^= (bNum & 0x0000FF00) >> 8;
    ivXord[3] ^= (bNum & 0x000000FF);

    if (aes128Ctr(key, ivXord, inputBytes, outputBytes, BLOCK_SIZE)) {
        return ENCRYPTION_ERROR;
    }

    return SUCCESS;
}

statusCode aes128Ctr(unsigned char *key_bytes, unsigned char *iv, unsigned char *plaintext, unsigned char *ciphertext, int length) {
    AES_KEY key;
    struct ctr_state state;
    init_ctr(&state, iv);

    if (AES_set_encrypt_key(key_bytes, AES_BLOCK_SIZE_BITS, &key)) {
        return ENCRYPTION_ERROR;
    }

    AES_ctr128_encrypt(plaintext, ciphertext, length, &key, state.ivec, state.ecount, &state.num);

    return SUCCESS;
}

int init_ctr(struct ctr_state *state, unsigned char *iv) {
    //aes_ctr128_encrypt requires 'num' and 'ecount' set to zero on the
    //first call.
    state->num = 0;
    memset(state->ecount, 0, 16);

    // Initialise counter in 'ivec' to 0
    memset(state->ivec + 8, 0, 8);

    //Copy IV into 'ivec'
    memcpy(state->ivec, iv, AES_IV_SIZE);
    return 0;
}

statusCode sha256Hash(unsigned char *input, int length, unsigned char *digest) {
    SHA256_CTX context;

    if(!SHA256_Init(&context))
        return ENCRYPTION_ERROR;

    if(!SHA256_Update(&context, input, length))
        return ENCRYPTION_ERROR;

    if(!SHA256_Final(digest, &context))
        return ENCRYPTION_ERROR;

    return SUCCESS;
}

