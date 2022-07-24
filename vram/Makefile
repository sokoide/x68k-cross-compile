TARGET=	vram.X
SRCS=	main.c \
		vram.c
HEADERS=$(wildcard *.h)
OBJS=$(SRCS:.c=.o)
HUMAN68K_TC=$(HOME)/Emu/x68000/cross/human68k
CC=$(HUMAN68K_TC)/bin/human68k-gcc
OBJCOPY=$(HUMAN68K_TC)/bin/human68k-objcopy

INCLUDE=-I$(HOME)/Emu/x68000/cross/human68k/human68k/include -I$(HOME)/Emu/x68000/cross/libc32b/include
CCFLAGS=$(INCLUDE) -std=c99 -O2 -g
LIB=-L$(HOME)/Emu/x68000/cross/human68k/human68k/lib -liocs

.PHONY:
	clean

$(TARGET): $(OBJS)
	$(CC) $^ -o tmp.elf $(LIB)
	$(OBJCOPY) -O xfile tmp.elf $@

%.o: %.c
	$(CC) $(CCFLAGS) -c $< -o $@

clean:
	rm -rf $(TARGET) *.elf *.o

install: $(TARGET)
	cp $(TARGET) $(HOME)/tmp
