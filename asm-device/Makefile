TARGET=ASMDEV.X
SRCS=main.s \
	 itoh.s
OBJS=$(SRCS:.s=.o)
CC=$(HUMAN68K_TC)/bin/human68k-gcc
AS=$(HUMAN68K_TC)/bin/human68k-as
LD=$(HUMAN68K_TC)/bin/human68k-ld
OBJCOPY=$(HUMAN68K_TC)/bin/human68k-objcopy
OBJDUMP=$(HUMAN68K_TC)/bin/human68k-objdump
LIB=-L$(HUMAN68K_TC)/human68k/lib
INCLUDE=-I$(HUMAN68K_TC)/human68k/include -I$(HUMAN68K_TC)/../libc32b/include
CCFLAGS=$(INCLUDE) -g -O2
LDFLAGS=$(LIB) -ldos -liocs -nostdlib

.PHONY:
	clean install dump

$(TARGET): $(OBJS)
	$(LD) $^ -o tmp.elf $(LDFLAGS) -e main -q
	$(OBJCOPY) -O xfile tmp.elf $@

%.o: %.s
	$(AS) $^ -o $@ -m68000 -I../include

clean:
	rm -rf $(TARGET) *.elf *.o

install: $(TARGET)
	cp $(TARGET) $(HOME)/tmp

dump: $(TARGET)
	$(OBJDUMP) -D $(TARGET)
