CC = gcc
FLAGS = -Wall -Werror -g
NAME = tinyFsDemo
LIB = tinyFSlib.a

libDisk.o: libDisk.c libDisk.h
	$(CC) $(FLAGS) -c libDisk.c libDisk.h
	cc -S $<

libTinyFS.o: libTinyFS.c libTinyFS.h
	$(CC) $(FLAGS) -c libTinyFS.c libTinyFS.h
	cc -S $<

$(LIB): libDisk.o libTinyFS.o 
	ar r $@ libDisk.o libTinyFS.o 
	ranlib $@	

clean:
	rm -f tinyFSlib.a
	rm -f *.s
	rm -f *.o