#include <stdio.h>
#include "libDisk.h"
#include "libTinyFS.h"

int main() {
    if (sodium_init() == -1) {
        return 1;
    }

    char *masterKeyFile = "secret.key";
    char *password = "pokemon";
    char *diskFileName = "tinyFSDisk.dat";
    printf("Mater Key File: secret.key\nPassword: pokemon\nDisk File Name: tinyFSDisk.dat\n\n");



    // generates a key file locked with the users password, 
    // dont worry about this
    printf("Generating mater key... ");
    generateMasterKey(masterKeyFile, password, NULL, NULL);
    printf("done\n");

    printf("Making filesystem... ");
    tfs_mkfs(diskFileName, 256*256, password, masterKeyFile);
    printf("done\n");

    printf("Mounting... ");
    tfs_mount(diskFileName, password, masterKeyFile);
    printf("done\n");

    printf("Opening file table...");
    int x = tfs_openFile("test");
    printf("done\n\n");

    printf("\nTest writing to file... ");
    tfs_writeFile(x, "Test Passed", 12);
    printf("finished writing\n");
    printf("Reading the written data: ");
    char test[12];
    for (int i = 0; i < 12; i++) {
        tfs_readByte(x, test);
        printf("\nTest:%c:%X\n", test[0], test[0]);
    }
    printf("\n");

    printf("Testing seek (display third byte of file)...\n");
    tfs_seek(x, 2);
    tfs_readByte(x, test);
    printf("Third byte:%c:%X\n\n", test[0], test[0]);

    printf("Testing readdir... \n");
    tfs_readdir();
    printf("done\n");

    printf("Testing file renaming... \n");
    tfs_rename(x,"renamed");
    tfs_readdir();
    printf("done\n");
    

    printf("Testing file deleition... \n");
    tfs_deleteFile(x);
    printf("\nTest:%c:%X\n", test[0], test[0]);
    printf("done\n");

    printf("Testing unmount... \n");
    tfs_unmount();
    printf("done\n");

    return 0;
}
