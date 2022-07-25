TARGET=	vram.X
SRCS=	main.c \
		vram.c
HEADERS=$(wildcard *.h)
OBJS=$(SRCS:.c=.o)
HUMAN68K_TC=$(HOME)/Emu/x68000/cross/human68k
CC=$(HUMAN68K_TC)/bin/human68k-gcc
OBJCOPY=$(HUMAN68K_TC)/bin/human68k-objcopy
OBJDUMP=$(HUMAN68K_TC)/bin/human68k-objdump

INCLUDE=-I$(HOME)/Emu/x68000/cross/human68k/human68k/include -I$(HOME)/Emu/x68000/cross/libc32b/include
CCFLAGS=$(INCLUDE) -std=c99 -O2 -g
LIB=-L$(HOME)/Emu/x68000/cross/human68k/human68k/lib
LDFLAGS=$(LIB) -ldos -liocs

.PHONY:
	clean install dump

$(TARGET): $(OBJS)
	$(CC) $^ -o tmp.elf $(LDFLAGS)
	$(OBJCOPY) -O xfile tmp.elf $@

%.o: %.c
	$(CC) -Wa,-adhlns="$@.lst" -c $< -o $@ $(CCFLAGS)

clean:
	rm -rf $(TARGET) *.elf *.o *.lst

install: $(TARGET)
	cp $(TARGET) $(HOME)/tmp

dump: $(TARGET)
	$(OBJDUMP) -D $(TARGET)
