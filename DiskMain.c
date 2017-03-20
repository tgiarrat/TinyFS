#include <stdio.h>
#include "libDisk.h"

int main() {
    if (sodium_init() == -1) {
        return 1;
    }

    char *passwordFile = "secret.key";
    char *password = "pokemon";
    char *disk = "cats.dat";

    // generate a random key file with a secure password
    generateMasterKey(passwordFile, password, NULL, NULL);

    // open a new disk with the password file
    int diskNum = openDisk(disk, 4096*5, password, passwordFile);
    unsigned char block[4096];
    readBlock(diskNum, 0, block);
    readBlock(diskNum, 1, block);
    readBlock(diskNum, 2, block);
    readBlock(diskNum, 3, block);
    readBlock(diskNum, 4, block);

    closeDisk(diskNum);
    diskNum = openDisk(disk, 0, "WRONG", passwordFile);

    readBlock(diskNum, 4, block);
    print_hex("BLOCK\n", block, BLOCK_SIZE);
    // prints out junk

    char *newPasswordFile = "new_secret.key";
    char *newPassword = "pokemon1";

    changePassword(passwordFile, newPasswordFile, password, newPassword);

    diskNum = openDisk(disk, 0, newPassword, newPasswordFile);
    readBlock(diskNum, 4, block);

    print_hex("BLOCK\n", block, 4096);
    closeDisk(diskNum);
    
    printf("DISK CLOSED\n");

    openDisk(disk, 0, password, passwordFile);


    /*
    diskNum = openDisk(disk, 4096*5, password, passwordFile);

    unsigned char block[4096];
    readBlock(diskNum, 2, block);

    print_hex("BLOCK\n", block, 4096);
    */

    /*

    generateMasterKey("key.key", "1234", "123412341234123412341234", "123412341234123412341234");
    char key[AES_KEY_SIZE];
    char iv[AES_IV_SIZE];
    extractMasterKey("key.key", "1234", key, iv);
    printf("%s\n", key);
    printf("%s\n", iv);
    */

    /*
       unsigned char *input = (unsigned char *)"asdfasdfasdflkajsd;lfkajfd";
       unsigned char output[SHA256_DIGEST_LENGTH];

       sha256Hash(input, 25, output);
       printf("%s\n", output);
       */

    /*

       unsigned char input[BLOCK_SIZE];
       unsigned char output[BLOCK_SIZE];
       unsigned char holder[BLOCK_SIZE];
       memset(input, 0, BLOCK_SIZE);
       memset(holder, 5, BLOCK_SIZE);

    //unsigned char key[AES_KEY_SIZE_BITS];

    unsigned char key[] = {
    0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77,
    0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff
    };

    statusCode res = aesCtrXorBlock(input, output, key, 0);
    printf("CIPHERTEXT\n");
    print_hex(output, BLOCK_SIZE);
    printf("\n");

    res = aesCtrXorBlock(output, holder, key, 0);
    printf("PLAINTEXT\n");
    print_hex(holder, BLOCK_SIZE);
    printf("\n");
    */


    /*
       unsigned char key[] = {
       0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77,
       0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff
       };

       openDisk("./file.txt", BLOCK_SIZE, key);

       unsigned char pt[BLOCK_SIZE];
       memset(pt, 1, BLOCK_SIZE);

       readBlock(0, 0, pt);

       print_hex(pt, BLOCK_SIZE);

       return 0;
       */

    //unsigned char salt[10];
    //generateRandomData(salt, 10);



}


