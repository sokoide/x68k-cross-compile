TARGET=ASM.X
SRCS=main.s
OBJS=$(SRCS:.s=.o)
HUMAN68K_TC=$(HOME)/Emu/x68000/cross/human68k
CC=$(HUMAN68K_TC)/bin/human68k-gcc
AS=$(HUMAN68K_TC)/bin/human68k-as
LD=$(HUMAN68K_TC)/bin/human68k-ld
OBJCOPY=$(HUMAN68K_TC)/bin/human68k-objcopy
OBJDUMP=$(HUMAN68K_TC)/bin/human68k-objdump
LIB=-L$(HOME)/Emu/x68000/cross/human68k/human68k/lib
INCLUDE=-I$(HOME)/Emu/x68000/cross/human68k/human68k/include -I$(HOME)/Emu/x68000/cross/libc32b/include
CCFLAGS=$(INCLUDE) -g -O2
LDFLAGS=$(LIB) -ldos -liocs -nostdlib

.PHONY:
	clean install dump

# TODO:
# For some reason, the messages are in .rodata section,
# it fails to load when it's linked by $(LD).
# If it's linked by $(CC), it adds 0x0002000a before the message1/2
# in the binary and it loads fine.
# No diff in disassembled code.

$(TARGET): $(OBJS)
	#$(LD) $< -o tmp.elf $(LDFLAGS) -e main
	$(CC)  -v $< -o tmp.elf $(LDFLAGS) -e main
	$(OBJCOPY) -O xfile tmp.elf $@

%.o: %.s
	$(AS) $^ -o $@ -m68000

clean:
	rm -rf $(TARGET) *.elf *.o

install: $(TARGET)
	cp $(TARGET) $(HOME)/tmp

dump: $(TARGET)
	$(OBJDUMP) -D $(TARGET)
