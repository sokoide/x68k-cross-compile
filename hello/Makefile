TARGET=HELLO.X
SRCS=hello.c
OBJS=$(SRCS:.c=.o)
HUMAN68K_TC=$(HOME)/Emu/x68000/cross/human68k
CC=$(HUMAN68K_TC)/bin/human68k-gcc
OBJCOPY=$(HUMAN68K_TC)/bin/human68k-objcopy
OBJDUMP=$(HUMAN68K_TC)/bin/human68k-objdump
LIB=-L$(HOME)/Emu/x68000/cross/human68k/human68k/lib
INCLUDE=-I$(HOME)/Emu/x68000/cross/human68k/human68k/include -I$(HOME)/Emu/x68000/cross/libc32b/include
CCFLAGS=$(INCLUDE) -g -O2

.PHONY:
	clean install dump

$(TARGET): $(OBJS)
	$(CC) $^ -o tmp.elf $(LIB)
	$(OBJCOPY) -O xfile tmp.elf $@

$(OBJS): $(SRCS)
	$(CC) -Wa,-adhlns="$@.lst" -c $< -o $@ $(CCFLAGS)

clean:
	rm -rf $(TARGET) *.elf *.o *.lst

install: $(TARGET)
	cp $(TARGET) $(HOME)/tmp

dump: $(TARGET)
	$(OBJDUMP) -D $(TARGET)
