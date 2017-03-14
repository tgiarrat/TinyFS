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

static void init_superblock(int disk){
   char *data = calloc(BLOCKSIZE, sizeof(char)); //allocate and clear memory
   data[0] = SUPERBLOCK; //set blocktype
   data[1] = MAGIC_NUM; //set magic number (second byte)
   data[2]
   /*
    
    buffer[2] = ((openDisks[disk].headFree)>>8) & 0xFF;
    buffer[3] = openDisks[disk].headFree & 0xFF; // First free block on disk
    buffer[4] = ((openDisks[disk].numBlocks)>>8) & 0xFF;
    buffer[5] = openDisks[disk].numBlocks & 0xFF; // Number of blocks on disk
    buffer[6] = ((openDisks[disk].freeBlocks)>>8) & 0xFF;
    buffer[7] = (openDisks[disk].freeBlocks) & 0xFF; // Number of free blocks on disk
    buffer[8] = ((openDisks[disk].inodeBlocks)>>8) & 0xFF;
    buffer[9] = openDisks[disk].inodeBlocks & 0xFF; // Number of inodes on disk
    
    
    memcpy(openDisks[disk].superblock, buffer, BLOCKSIZE);
    
    writeBlock(disk, 0, buffer); // Write superblock, always at block 0
    free(buffer);
    
    
    */
}

int init_disk(int diskNum, int numBlocks) {
   
   //initialize and write superblock:
   init_superblock();
}



int tfs_mkfs(char *filename, int nBytes){
   
   //todo: error check for num bytes
   
   int diskNum = openDisk(filename, nBytes);
   if (diskNum < 0) { // error
      //to do: handle open disk error
   }
   else { //format the file to be a mountable disk
      
      int blockCount = nBytes / BLOCKSIZE; //number of blocks to make
      
      init_disk();//initialize all data to 0x00
      
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




