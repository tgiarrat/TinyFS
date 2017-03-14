



int readBlock(int disk, int bNum, void *plaintext) {
   disk_ctx *ctx;
   if (!(ctx = disks[disk])) {
      return DISK_NOT_FOUND;
   }
   
   unsigned char ciphertext[BLOCK_SIZE];
   fseek(ctx->fp, bNum * BLOCK_SIZE, SEEK_SET);
   fread(ciphertext, sizeof(unsigned char), BLOCK_SIZE, ctx->fp);
   print_hex(ciphertext, BLOCK_SIZE);
   
   if (aesCtrXorBlock(ciphertext, plaintext, ctx->key, bNum))
      return ENCRYPTION_ERROR;
   
   return SUCCESS;
}

int writeBlock(int disk, int bNum, void *plaintext) {
   disk_ctx *ctx;
   if (!(ctx = disks[disk])) {
      return DISK_NOT_FOUND;
   }
   
   print_hex(ctx->key, AES_KEY_SIZE);
   printf("here\n");
   
   unsigned char ciphertext[BLOCK_SIZE];
   if (aesCtrXorBlock(plaintext, ciphertext, ctx->key, bNum))
      return ENCRYPTION_ERROR;
   
   print_hex(ciphertext, BLOCK_SIZE);
   printf("--%d\n", bNum*BLOCK_SIZE);
   
   fseek(ctx->fp, bNum * BLOCK_SIZE, SEEK_SET);
   fwrite(ciphertext, sizeof(unsigned char), BLOCK_SIZE, ctx->fp);
   fflush(ctx->fp);
   
   return SUCCESS;
}


int openDisk(char *filename, int nBytes) {
   int mount_idx;
   for (mount_idx = 0; disks[mount_idx] != NULL && mount_idx != MAX_DISKS; ++mount_idx);
   
   if (mount_idx == MAX_DISKS) {
      return -1;
   }
   
   disks[mount_idx] = malloc(sizeof(disk_ctx));
   disk_ctx *disk = disks[mount_idx];
   
   disk->fp = fopen(filename, "r+");
   
   disk->size = nBytes;
   //extractMasterKey(masterKeyFile, password, disk->key); password and the file were in parameters
   
   if (nBytes > 0) {
      unsigned char *zero_block[BLOCK_SIZE];
      // write the entire disk with encrypted blank data
      if (nBytes % BLOCK_SIZE != 0) {
         printf("nBytes is not an integral number of blocksize\n");
      }
      
      int blocks = nBytes / BLOCK_SIZE;
      
      int writeStatus;
      for (int block = 0; block < blocks; block++) {
         printf("writing block %d\n", block);
         if ((writeStatus = writeBlock(mount_idx, block, zero_block))) {
            printf("ERROR writing blocks, status: %d\n", writeStatus);
         }
      }
   }
   
   return mount_idx;
}
