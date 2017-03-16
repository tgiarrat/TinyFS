//page 548

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "libTinyFS.h"
#include "libDisk.h"

enum blockType
{
    SUPERBLOCK = 1,
    INODE = 2,
    FILE_EXTENT = 3,
    FREE = 4
};

static int init_superblock(int blkCount, int diskNum)
{
    SuperBlock sBlk;
    sBlk.type = SUPERBLOCK;
    sBlk.magicNum = MAGIC_NUM;
    sBlk.root_inode = 1; //0th block is the superblock
    sBlk.next_free = 2;
    sBlk.last_free = blkCount - 1;

    memset(sBlk.data, 0, BLOCKSIZE - 5); //clears the rest of the data of the block

    if (writeBlock(diskNum, 0, &sBlk) < 0)
    {
        //to do: error
        return -1;
    }

    FreeBlock fBlk;
    fBlk.type = FREE;
    fBlk.magic_num = MAGIC_NUM;
	int i;

	for (i = 2; i < blkCount; i++) {
        if (i == blkCount - 1){
            fBlk.next_free = 0;
        }
        else{
            fBlk.next_free = i + 1;
        }
    	memset(fBlk.data, 0, BLOCKSIZE-3);

    	if (writeBlock(diskNum, i, &fBlk) < 0) {
    		//to do: error
            return -1;
    	}
    }
    return 0;
}

int tfs_mkfs(char *filename, int nBytes)
{
    //todo: error check for num bytes

    int diskNum = openDisk(filename, nBytes);
    if (diskNum < 0)
    {   // error
        //to do: handle open disk error
    }

    //format the file to be a mountable disk

    int blockCount = nBytes / BLOCKSIZE; //number of blocks to make

    init_superblock( blockCount, diskNum); //initializes the superblock
    return 0;
}

int tfs_mount(char *diskname)
{
    return 0;
}
int tfs_unmount(void)
{
    return 0;
}
fileDescriptor tfs_openFile(char *name)
{
    return 0;
}
int tfs_closeFile(fileDescriptor FD)
{
    return 0; 
}
int tfs_writeFile(fileDescriptor FD, char *buffer, int size)
{
    return 0;
}
int tfs_deleteFile(fileDescriptor FD)
{
    return 0;
}
int tfs_readByte(fileDescriptor FD, char *buffer)
{
    return 0;
}
int tfs_seek(fileDescriptor FD, int offset)
{
    return 0;
}