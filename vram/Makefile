TARGET=	vram.X
SRCS=	main.c \
		vram.c
HEADERS=$(wildcard *.h)
OBJS=$(SRCS:.c=.o)
CC=$(HUMAN68K_TC)/bin/human68k-gcc
OBJCOPY=$(HUMAN68K_TC)/bin/human68k-objcopy
OBJDUMP=$(HUMAN68K_TC)/bin/human68k-objdump

INCLUDE=-I$(HUMAN68K_TC)/human68k/include -I$(HUMAN68K_TC)/../libc32b/include
CCFLAGS=$(INCLUDE) -O2 -g
LIB=-L$(HUMAN68K_TC)/human68k/lib
LDFLAGS=$(LIB) -ldos -liocs -lm

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
