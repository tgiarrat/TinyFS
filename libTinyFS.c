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

static int system_mounted = 0;
static int block_count = 0;
static int mounted_disk;

static FileTable open_file_table;

static int init_superblock(int blkCount, int diskNum) {
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

int tfs_mkfs(char *filename, int nBytes, char *password, char *masterKeyFile) {
    //todo: error check for num bytes

    int diskNum = openDisk(filename, nBytes, password, masterKeyFile);
    if (diskNum < 0)
    {   // error
        //to do: handle open disk error
        return -1; 
    }

    //format the file to be a mountable disk

    block_count = nBytes / BLOCKSIZE; //number of blocks to make

    init_superblock( block_count, diskNum); //initializes the superblock
    return 0;
}

int tfs_mount(char *diskname, char *password, char *masterKeyFile) {
    char block[BLOCKSIZE];
    int i = 0;

    if (system_mounted){
        //to do: proper error shit
        return -2; 
    }

    if (diskname == NULL) {
        return -2;
        //to do: proper error checking
    }

    mounted_disk = openDisk(diskname, 0, password, masterKeyFile); //0 means existing disk opens

    if (mounted_disk == -1) {
        //to do : error
        return -2;
    }

    system_mounted = 1;

    for(;i < block_count; i++) {
        readBlock(mounted_disk, i, block);
        if(block[1] != MAGIC_NUM) { //not of tinyfs type
            //to do: error 
            return -2;          
        }
    }

    //init file table?

    open_file_table->head = NULL;
    open_file_table->tail = NULL;
    open_file_table->numOpenFiles = 0;
    open_file_table->lastFile = 0;
    //open_file_table->maxFiles = ;


    return 0;
}
int tfs_unmount(void)

    if (system_mounted == 0) {
        return -1; 
        //to do error
    }

    mounted_disk = -1; //to do: check later
    system_mounted = 0;


    //clean up open file table
    FileTableNode *curNode = open_file_table->head;
    FileTableNode *temp;
	while (curNode) {
		temp = curNode;
		curNode = curNode->next;
		free(temp);
	}
	free(curNode);
    return 0;
}

//returns file in the file table with the file descriptor
FileTableNode* getNode(fileDescriptor fd) {
    FileTableNode *node = open_file_table.head;

    while (node) {
        if (node->fd == fd) {
                return node;
        }
        node = node->next;
    }

    return NULL; //node not in file table

}
static int opened = 0;
fileDescriptor tfs_openFile(char *name) {
    SuperBlock sb;
    FileTableNode *node;
    //check if already open
    node = open_file_table.head;
    while (node) {
        if (!strcmp(name, node->name)) return node.fd;
        node = node->next;
    }
    opened++;
    //not already open so create a new FileTableNode
    node = malloc(sizeof(FileTableNode));
    if (!open_file_table.head) open_file_table.head = node;
    if (open_file_table.tail) open_file_table.tail->next = node;
    open_file_table.tail = node;
    
    //check if file exisits
    readBlock(mounted_disk, 0, &sb);
    Inode inode;
    uint8_t idx = sb.root_inode;
    readBlock(mounted_disk, sb.root_inode, &inode);
    while (inode.type != FREE) {
        if (!strcmp(inode.fileName, name)) {
            // this is the right inode
            node->bNum = idx;
            node->ptr = 0;
            node->fd = opened;
        }
        if (!inode.next_inode) return ERROR_DISK_FULL; //TODO: file not found
        idx = inode.next_inode;

        readBlock(mounted_disk, idx, &inode);
    }
    
    //file not found - create a file
    sb.next_free = inode.next_inode;
    inode.name = name;
    inode.data_extent = 0;
    
    node->bNum = idx;
    node->ptr = 0;
    node->fd = opened;
    
    //write sb and inode
    writeBlock(mounted_disk, idx, &inode);
    writeBlock(mounted_disk, 0, &sb);
    return 0;
}
int tfs_closeFile(fileDescriptor FD) {
    FileTableNode *node = open_file_table.head;
    FileTableNode *prev;
    prev = 0;
    while (node) {
        if (node->fd == fd) {
                if (prev) prev->next = node->next;
                else open_file_table.head = node->next;
                if (open_file_table.tail == node)
                    open_file_table.tail = prev;
                free(node);
                return SUCCESS;
        }
        prev = node;
        node = node->next;
    }
    return ERROR_BAD_FD; 
}
int tfs_writeFile(fileDescriptor FD, char *buffer, int size) {
    return 0;
}
int tfs_deleteFile(fileDescriptor FD) {
    SuperBlock sb;
    readBlock(mounted_disk, 0, &sb);
    Inode inode;
    uint8_t idx = sb.root_inode;
    readBlock(mounted_disk, sb.root_inode, &inode);
    FileTableNode *delFT = getNode(FD);
    Inode del;
    readBlock(mounted_disk, delFT->bNum, &del);
    //find prev inode and link it to the next one
    if (sb.root_inode == delFT->bNum) {
        sb.root_inode = del.next_inode;
    }
    else {
        while (inode.type == INODE && inode.next_inode != delFT->bNum) {
            readBlock(mounted_disk, inode.next_inode, &inode);
        }
        if (inode.type==INODE) inode.next_inode = del.next_inode;
        else return ERROR_BAD_FD;
    }
    writeBlock(mounted_disk, 0, &sb);    
    
    
    
    //mark all extents as free and add to sb free chain
    Extent ext;
    int temp;
    while (del.data_extent) {
        readBlock(mounted_disk, del.data_extent, &ext);
        temp = ext.next_extent;
        addToFree(del.data_extent);
        del.data_extent = temp;
    }
    
    //mark inode as free and add to sb free chain
    addToFree(delFT->bNum);
    
    
    
    
    tfs_closeFile(fd);
    return 0;
}

int addToFree(int bNum) {
    SuperBlock sb;
    FreeBlock free;
    FreeBlock tail;
    readBlock(mounted_disk, 0, &sb);
    readBlock(mounted_disk, bNum, &free );
    readBlock(mounted_disk, sb.last_free, &tail );
    free.type = FREE;
    free.next_free = 0;
    tail.next_free = bNum;
    sb.last_free = bNum;
    return 0;
}

// set block 
// get free block
// 

int tfs_readByte(fileDescriptor FD, char *buffer) {
    FileTableNode *node = getNode(FD);
    Inode inode;

    if (file_node == NULL) {
        //to do: errorr
        return -1;
    }
    if (readBlock(mounted_disk, file_node->bNum, &inode) < 0) {
        return -1;
        //to do: error
    }

    int offset = node->ptr;

    Extent currExtent;
    readBlock(mounted_disk, node->data_extent, &currExtent);

    while (offset > EXTENT_SIZE) {
        readBlock(mounted_disk, currExtent->next_extent, &currExtent);
        offset -= EXTENT_SIZE;
    }

    *buffer = currExtent.data[offset];

    return 0;

}
int tfs_seek(fileDescriptor FD, int offset) {   
    FileTableNode *file_node;
    Inode inode;

    file_node = getFile(fd);

    if (file_node == NULL) {
        //to do: errorr
        return -1;
    }

    if (readBlock(mounted_disk, file_node->bNum, &inode) < 0) {
        return -1;
        //to do: error
    }
    if (offset < 0 || offset >= inode.size) {
        return -1;
        //to do: error
    }

    file_node->ptr = offset;
    return 1;
}
