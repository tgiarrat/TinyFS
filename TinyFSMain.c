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

    tfs_mount(diskFileName, password, masterKeyFile);

    // DO TINY FS THINGS HERE
    // tfs_mount(diskFileName, password, masterKeyFile)

    tfs_unmount();

    return 0;
}
