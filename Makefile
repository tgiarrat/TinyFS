
FLAGS = -Wall -Werror -g
NAME = tinyFsDemo
LIB = tinyFSlib.a

libDisk.o: libDisk.c libDisk.h
	gcc $(FLAGS) -c libDisk.c libDisk.h
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