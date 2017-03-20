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
    printf("Generating master key file with and encrypting it with password: %s\n\n", password);

    generateMasterKey(passwordFile, password, NULL, NULL);

    // open a new disk with the password file
    int diskNum = openDisk(disk, BLOCK_SIZE*5, password, passwordFile);
    unsigned char block[BLOCK_SIZE];
    memset(block, 0, BLOCK_SIZE);

    print_hex("writing block 0 which is...\nNOTE: block is encrypted with the password: pokemon\n", block, BLOCK_SIZE);
    printf("\n");

    readBlock(diskNum, 0, block);
    readBlock(diskNum, 1, block);
    readBlock(diskNum, 2, block);
    readBlock(diskNum, 3, block);
    readBlock(diskNum, 4, block);

    closeDisk(diskNum);
    diskNum = openDisk(disk, 0, "WRONG", passwordFile);

    readBlock(diskNum, 0, block);
    print_hex("Reading block 0 with password: WRONG\n", block, BLOCK_SIZE);
    printf("\n");
    // prints out junk

    char *newPasswordFile = "new_secret.key";
    char *newPassword = "pokemon1";

    changePassword(passwordFile, newPasswordFile, password, newPassword);
    printf("Changing password from 'pokemon', to 'pokemon1'\n\n");

    diskNum = openDisk(disk, 0, newPassword, newPasswordFile);
    memset(block, 1, BLOCK_SIZE);
    readBlock(diskNum, 1, block);

    print_hex("reading block 0 with the key: pokemon1\n", block, BLOCK_SIZE);
    printf("\n");
    closeDisk(diskNum);
    
    printf("DISK CLOSED\n");

    openDisk(disk, 0, password, passwordFile);
}


