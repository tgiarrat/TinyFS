

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <openssl/aes.h> 
#include <openssl/sha.h>

#define BLOCK_SIZE 4096 // bytes
#define AES_BLOCK_SIZE_BITS 128
#define AES_KEY_SIZE 16
#define AES_KEY_SIZE_BITS 128
#define AES_IV_SIZE 8
#define MAX_DISKS 512
#define SALT_SIZE 16 // bytes
#define MASTER_KEY_MATERIAL_SIZE 320//128 + 128 + 64

struct ctr_state {
    unsigned char ivec[16];  /* ivec[0..7] is the IV, ivec[8..15] is the big-endian counter */
    unsigned int num;
    unsigned char ecount[16];
} ctr_state;


typedef struct disk_ctx {
    FILE *fp;
    int size;

    unsigned char *key;
} disk_ctx;

typedef enum {SUCCESS, ENCRYPTION_ERROR, DISK_NOT_FOUND} statusCode;

disk_ctx *disks[MAX_DISKS];



/* readBlock() reads an entire block of BLOCKSIZE bytes from the open disk (identified by ‘disk’)
and copies the result into a local buffer, block (which must be at least of BLOCKSIZE bytes). The
 bNum is a logical block number, which must be translated into a byte offset within the disk. The 
 translation from logical to physical block is straightforward: bNum=0 is the very first byte of
  the file. bNum=1 is BLOCKSIZE bytes into the disk, bNum=n is n*BLOCKSIZE bytes into the disk
  . On success, it returns 0. -1 or smaller is returned if disk is not available (hasn’t been opened) 
  or any other failures. readBlock will also perform the decryption operation. You should define your own
   error code system. */
int readBlock(int disk, int bNum, void *block);

/* writeBlock() takes disk number ‘disk’ and logical block number ‘bNum’ and encrypts and then writes the content 
of the buffer ‘block’ to that location. ‘block’ must be integral with BLOCKSIZE. Just as in readBlock(), writeBlock() 
must translate the logical block bNum to the correct byte position in the file. On success, it returns 0. -1 or smaller
 is returned if disk is not available (i.e. hasn’t been opened) or any other failures. You should define your own error
  code system. */
int writeBlock(int disk, int bNum, void *block);


/* This functions opens a regular UNIX file and designates the first nBytes of it as space for the emulated disk. 
If nBytes is not exactly a multiple of BLOCKSIZE then the disk size will be the closest multiple of BLOCKSIZE that
 is lower than nByte (but greater than 0) If nBytes is less than BLOCKSIZE failure should be returned. If nBytes > 
 BLOCKSIZE and there is already a file by the given filename, that file’s content may be overwritten. If nBytes is 0,
  an existing disk is opened, and should not be overwritten. There is no requirement to maintain integrity of any file 
  content beyond nBytes. The return value is -1 on failure or a disk number on success. */
int openDisk(char *filename, int nBytes);
