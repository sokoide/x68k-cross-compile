TARGET=NOOS.X
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
LDFLAGS=$(LIB) -lx68kiocs -nostdlib -Tlinker.ld

DISKIMG=$(TARGET:.X=.xdf)
EMPTYDISKIMG=empty.xdf

.PHONY:
	clean install dump bin disk readelf

$(TARGET): $(OBJS) linker.ld
	$(LD) --strip-all $(OBJS) -o $(TARGET).elf $(LDFLAGS) -e boot -q
	elf2x68k.py -s -o $(TARGET) $(TARGET).elf

%.o: %.s
	$(AS) --strip-local-absolute $^ -o $@ -m68000 -I../include

clean:
	rm -rf $(TARGET) *.elf *.o *.bin $(DISKIMG)

install: $(TARGET)
	cp $(TARGET) $(HOME)/tmp

dump: $(TARGET)
	$(OBJDUMP) -D $(TARGET).elf

bin: $(TARGET)
	$(OBJCOPY) -O binary $(TARGET).elf $(TARGET).bin

disk: bin $(EMPTYDISKIMG)
	cat $(TARGET).bin $(EMPTYDISKIMG) | dd bs=1 count=1261568 of=$(DISKIMG)
	@echo $(DISKIMG) has been created

$(EMPTYDISKIMG):
	# 1024 bytes/sector
	# 8 sectors * 77 tracks * 2 sides = 1232
	echo making $(DISKIMG)
	dd if=/dev/zero of=$(EMPTYDISKIMG) bs=1024 count=1232


readelf: $(TARGET)
	$(READELF) -a $(TARGET).elf
