//page 548

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "libTinyFS.h"
#include "libDisk.h"

enum blockType {
   SUPERBLOCK = 1,
   INODE = 2,
   FILE_EXTENT = 3,
   FREE = 4
};

static void init_superblock(SuperBlock *sBlk, int blkCount){
   
   sBlk->type = SUPERBLOCK;
   sBlk->magicNum = MAGIC_NUM;
   sBlk->root_inode = 1;//0th block is the superblock
   sBlk->next_free = 2;
   sBlk->last_free = blkCount - 1;
   
   memset(sBlk->data, 0, BLOCKSIZE-5);//clears the rest of the data of the block
}




int tfs_mkfs(char *filename, int nBytes){
   
   //todo: error check for num bytes
   
   int diskNum = openDisk(filename, nBytes);
   if (diskNum < 0) { // error
      //to do: handle open disk error
   }
   
   //format the file to be a mountable disk
      
   int blockCount = nBytes / BLOCKSIZE; //number of blocks to make
   
   SuperBlock *sBlk;
   init_superblock(sBlk, blockCount); //initializes the superblock
   
   //initialize free blocks:
   FreeBlock fBlk;
   int i;
   
   for (i = 2; i < ) {
      
   }
   
   
}

int tfs_mount(char *diskname){
   
}

int tfs_unmount(void){
   
}

fileDescriptor tfs_openFile(char *name) {
   
   
}

int tfs_closeFile(fileDescriptor FD){
   
}

int tfs_writeFile(fileDescriptor FD,char *buffer, int size){
   
}

int tfs_deleteFile(fileDescriptor FD){
   
}


int tfs_readByte(fileDescriptor FD, char *buffer){
   
}

int tfs_seek(fileDescriptor FD, int offset){
   
}




