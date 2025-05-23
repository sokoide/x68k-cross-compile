TARGET=ASMMIN.X
SRCS=main.s
OBJS=$(SRCS:.s=.o)

CC=m68k-xelf-gcc
AS=m68k-xelf-as
LD=m68k-xelf-ld
OBJCOPY=m68k-xelf-objcopy
OBJDUMP=m68k-xelf-objdump
READELF=m68k-xelf-readelf

INCLUDE=-I$(XELF_BASE)/m68k-elf/include
LIB=-L$(XELF_BASE)/m68k-elf/lib

CCFLAGS=$(INCLUDE) -g -O2
LDFLAGS=$(LIB) -lx68kdos -lx68kiocs -nostdlib
ASFLAGS=-m68000 --register-prefix-optional --traditional-format -I../include

.PHONY:
	clean install dump readelf

$(TARGET): $(OBJS)
	$(LD) $^ -o $(TARGET).elf $(LDFLAGS) -e main -q
	elf2x68k.py -o $(TARGET) $(TARGET).elf

%.o: %.s
	$(AS) $^ -o $@ $(ASFLAGS)

clean:
	rm -rf $(TARGET) *.elf *.o

install: $(TARGET)
	cp $(TARGET) $(HOME)/tmp

dump: $(TARGET)
	$(OBJDUMP) -D $(TARGET).elf

readelf: $(TARGET)
	$(READELF) -a $(TARGET).elf
