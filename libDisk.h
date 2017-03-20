#ifndef LIBDISK_H

#define LIBDISK_H

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <openssl/aes.h>
#include <openssl/sha.h>
#include <sodium.h>

#define BLOCK_SIZE 128 // bytes
#define AES_BLOCK_SIZE_BITS 128
#define AES_KEY_SIZE 16
#define AES_KEY_SIZE_BITS 128
#define AES_IV_SIZE 8
#define MAX_DISKS 512
#define SALT_SIZE 16 // bytes
#define MASTER_KEY_MATERIAL_SIZE 40//16 + 16 + 8

typedef enum {SUCCESS, ENCRYPTION_ERROR, DISK_NOT_FOUND} statusCode;

// state of a mounted disk
typedef struct disk_ctx {
    FILE *fp;
    int size;

    unsigned char *key;
    unsigned char *iv;
} disk_ctx;


disk_ctx *disks[MAX_DISKS];

/***************************
*******DISK ENCRYPTION******
****************************/

// state for CTR mode block cipher
struct ctr_state {
    unsigned char ivec[16];  /* ivec[0..7] is the IV, ivec[8..15] is the big-endian counter */
    unsigned int num;
    unsigned char ecount[16];
} ctr_state;

int init_ctr(struct ctr_state *state, unsigned char *iv);

int print_hex(char *pre, unsigned char *bytes, int size);

void generateRandomData(unsigned char *data, int length);

int encryptMasterKey(FILE *file, unsigned char *password, int passLength);

int decryptMasterKey(FILE *file, unsigned char *password, int passLength);

int changePassword(char *oldFile, char *newFile, char *oldPassword, char *newPassword);

int generateMasterKey(char *file, char *password, unsigned char *key, unsigned char *iv);

int extractMasterKey(char *file, char *password, unsigned char *keyOut, unsigned char *ivOut);

int aesXorMasterKey(unsigned char *masterKeyIn, char *password, unsigned char *salt, unsigned char *iv, unsigned char *masterKeyOut);

int PBKDF(char *password, unsigned char *salt, unsigned char *result);

int getSalt(unsigned char *salt);
statusCode sha256Hash(unsigned char *input, int length, unsigned char *digest);

statusCode aesCtrXorBlock(unsigned char *inputBytes, unsigned char *outputBytes, unsigned char *key, unsigned char *iv, int bNum);

statusCode aes128Ctr(unsigned char *key, unsigned char *iv, unsigned char *plaintext, unsigned char *ciphertext, int length);


/***************************
***********PART ONE*********
****************************/

/* This function opens a regular file and designates the first nBytes of it as space for the emulated disk. nBytes should be an integral number of the block size. If nBytes > 0 and there is already a file by the given filename, that file’s content may be overwritten. If nBytes is 0, an existing disk is opened, and should not be overwritten. There is no requirement to maintain integrity of any file content beyond nBytes. The return value is -1 on failure or a disk number on success. */
int openDisk(char *filename, int nBytes, char *password, char *masterKeyFile);

/* This function unmounts the open disk (identified by ‘disk’). */
int closeDisk(int disk);

/* readBlock() reads an entire block of BLOCKSIZE bytes from the open disk (identified by ‘disk’) and copies the result into a local buffer, block (which must be at least of BLOCKSIZE bytes). The bNum is a logical block number, which must be translated into a byte offset within the disk. The translation from logical to physical block is straightforward: bNum=0 is the very first byte of the file. bNum=1 is BLOCKSIZE bytes into the disk, bNum=n is n*BLOCKSIZE bytes into the disk. On success, it returns 0. -1 or smaller is returned if disk is not available (hasn’t been opened) or any other failures. readBlock will also perform the decryption operation. You should define your own error code system. */
int readBlock(int disk, int bNum, void *block);

/* writeBlock() takes disk number ‘disk’ and logical block number ‘bNum’ and encrypts and then writes the content of the buffer ‘block’ to that location. ‘block’ must be integral with BLOCKSIZE. Just as in readBlock(), writeBlock() must translate the logical block bNum to the correct byte position in the file. On success, it returns 0. -1 or smaller is returned if disk is not available (i.e. hasn’t been opened) or any other failures. You should define your own error code system. */
int writeBlock(int disk, int bNum, void *block);



#endif
