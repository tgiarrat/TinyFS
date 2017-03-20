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

    // generates a key file locked with the users password, 
    // dont worry about this
    generateMasterKey(masterKeyFile, password, NULL, NULL);

    tfs_mkfs(diskFileName, 256*256, password, masterKeyFile);
    tfs_mount(diskFileName, password, masterKeyFile);
    int x = tfs_openFile("test");
    tfs_writeFile(x, "testMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMetestMe", 337);

    char test[7];
    for (int i = 0; i < 7; i++) {
        tfs_readByte(x, test);
        printf("\nTest:%c:%X\n", test[0], test[0]);
    }
    tfs_seek(x, 2);
    tfs_readByte(x, test);
    tfs_readdir();
    tfs_rename(x,"renamed");
    tfs_readdir();
    
    tfs_deleteFile(x);
    printf("\nTest:%c:%X\n", test[0], test[0]);

    
    tfs_unmount();

    return 0;
}
