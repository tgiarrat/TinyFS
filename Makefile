
FLAGS = -Wall -Werror -g
NAME = tinyFsDemo
LIB = tinyFSlib.a

LIBFLAGS= -lcrypto -lsodium -lssl
CFLAGS=$(pkg-config --cflags libsodium)
LDFLAGS=$(pkg-config --libs libsodium)

############
# LIB DISK #
############
make DiskMain: libDisk.o libDisk.h
	gcc $(FLAGS) $(CFLAGS) $(LDFLAGS) DiskMain.c *.o libDisk.h $(LIBFLAGS) -o DiskMain

libDisk.o: libDisk.c libDisk.h
	gcc $(FLAGS) -c libDisk.c libDisk.h
	gcc -S $<

libDisk.c: libDisk.h
	touch DiskMain.c

libDisk.c: libDisk.h
	touch libDisk.c

###############
# LIB TINY FS #
###############
libTinyFS.o: libTinyFS.c libTinyFS.h
	gcc $(FLAGS) -c libTinyFS.c libTinyFS.h
	gcc -S $<

$(LIB): libDisk.o libTinyFS.o 
	ar r $@ libDisk.o libTinyFS.o 
	ranlib $@	

###########
# GENERAL #
###########
clean:
	rm -f tinyFSlib.a
	rm -f *.s
	rm -f *.o
	rm -f *.gch