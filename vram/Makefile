TARGET=	vram.x
SRCS=	main.c \
		vram.c
HEADERS=$(wildcard *.h)
OBJS=$(SRCS:.c=.o)
CC=m68k-xelf-gcc
OBJDUMP=m68k-xelf-objdump

INCLUDE=-I$(XELF_BASE)/m68k-elf/include
LIB=-L$(XELF_BASE)/m68k-elf/lib

CCFLAGS=$(INCLUDE) -O2 -g
LDFLAGS=$(LIB) -lx68kdos -lx68kiocs

.PHONY:
	clean install dump

$(TARGET): $(OBJS)
	$(CC) $^ -o $(TARGET) -Xlinker "$(LDFLAGS)"

%.o: %.c
	$(CC) -Wa,-adhlns="$@.lst" -c $< -o $@ $(CCFLAGS)

clean:
	rm -rf $(TARGET) *.elf *.o *.lst

install: $(TARGET)
	cp $(TARGET) $(HOME)/tmp

dump: $(TARGET)
	$(OBJDUMP) -D $(TARGET).elf
