
FLAGS = -Wall -Werror -g
NAME = tinyFsDemo
LIB = tinyFSlib.a

LIBFLAGS= -lcrypto -lsodium -lssl
CFLAGS=$(pkg-config --cflags libsodium)
LDFLAGS=$(pkg-config --libs libsodium)

libDisk.o: libDisk.c libDisk.h
	gcc $(FLAGS) $(CFLAGS) $(LDFLAGS) -c libDisk.c libDisk.h $(LIBFLAGS)
	gcc -S $<

libTinyFS.o: libTinyFS.c libTinyFS.h
	gcc $(FLAGS) -c libTinyFS.c libTinyFS.h
	gcc -S $<

$(LIB): libDisk.o libTinyFS.o 
	ar r $@ libDisk.o libTinyFS.o 
	ranlib $@	

clean:
	rm -f tinyFSlib.a
	rm -f *.s
	rm -f *.o
	rm -f *.gch